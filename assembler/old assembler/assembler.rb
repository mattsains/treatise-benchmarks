#!/usr/bin/env ruby
require File.dirname(__FILE__)+'/instructions.rb'

USE_REAL_REG_NAMES = ARGV.include? '-r'
USE_CONVENTIONAL_BYTECODE = ARGV.include? '-c'
ARGV_WITHOUT_FLAGS = ARGV - ['-r', '-c']

def error line, msg
  puts "="*60
  puts "Error with '#{line}':"
  puts "  #{msg}"
  puts "="*60
  x=1/0
  abort
end

if argv_without_flags[0] == nil
  puts "Doug's modified 'Matt's assembler'"
  puts ""
  puts "Invocation:"
  puts " assembler.rb input_file [output_file] [-r -c]"
  puts ""
  puts " output_file defaults to a.out"
  puts " -r flag prints the names of the actual registers used in x64,"
  puts "   to make debugging a little easier."
  puts " -c flag generates code in the more conventional bytecode format"
  puts "   defined by Douglas:"
  puts "    bits  |  meaning"
  puts "   --------------------"
  puts "    0..3  |  register 2"
  puts "    4..7  |  register 1"
  puts "    8..16 |  opcode"
else
  File.open(argv_without_flags[0],"r") do |f|

class BetterFile < File
  alias _readline readline
  alias _eof? eof?
  
  @next = nil
  
  def initialize(a, b)
    super(a, b)
    @next = _readline
    @next = @next.split(';')[0] #remove comments
    @next.strip!
  end
  
  def readline
    if _eof?
      temp = @next
      @next = nil
      return temp
    else
      temp = @next
      line = super
      line = line.split(';')[0] #remove comments
      line.strip!
      @next = line
      return temp
    end
  end
  
  def eof?
    super & (@next == nil)
  end
  
  def peek
    if eof?
      return nil
    else
      return @next
    end
  end
end

class Program
  class Fixup
    attr_accessor :instr_base_addr
    attr_accessor :fixup_addr
    attr_accessor :name
    def initialize(instr_base_addr, fixup_addr, name)
      self.instr_base_addr = instr_base_addr
      self.fixup_addr = fixup_addr
      self.name = name
    end
  end

  def initialize
    # Stores the absolute location of symbols: label => address
    @abs_symbols = {}

    # Stores symbols that do not undergo arithmetic
    # ie., object/function member indexes
    @fake_symbols = []

    # Stores display messages by address: addr => msg
    @display_messages = {}
    
    # Last symbol in the source file (used for local labels)
    @last_symbol = nil

    # Stores a queue of address substitutions of type Fixup
    # Fixups are always sixteen bits
    @fixups = []

    # Array of bytes to be written to output file
    @output_bytes = []

    # Constants to relocate to the end of the program.
    # Constants might also appear as names in fixups.
    # They are referenced as _imm_val or _imm_mval for negatives
    @constants = []
  end
  
  def hex n
    ("%04x"%n).tr('..','ff').reverse[0, 4].reverse
  end
  
  def bin n
    ("0b%b"%n)
  end

  def write_bytes(data, bytes, buffer = nil)
    if data >=0
      if data >> (bytes*8) != 0
        error(data,"#{data} does not fit in #{bytes} bytes")
      end
    else
      if (~(data >> (bytes*8))) != 0
        error(data,"#{data} does not fit in #{bytes} bytes")
      end
    end

    for i in 0...bytes
      if buffer == nil
        @output_bytes << ((data >> (i*8)) & 0xFF)
      else
        buffer << (data >> (i*8)) & 0xFF
      end
    end
  end

  def add_label(label, fake = false)
    if label[0] == '.'
      if @last_symbol == nil
        error(label, "Local label with no scope")
      else
        label = @last_symbol + label
      end
    end

    if @abs_symbols.has_key? label
      error(label, "#{label} has already been defined")
    end

    @abs_symbols[label] = @output_bytes.length
    @fake_symbols << label if fake

    if not label.include? '.'
      @last_symbol = label
    end
  end
  
  def parse_label(file)
    line = file.readline
    label = line.match(/\.?[^\d\W]\w*/)[0] # optional ., alphabet, alphanumeric*
    add_label(label)
  end

  def parse_constant(file)
    line = file.readline
    @display_messages[@output_bytes.length] = line
    if line.start_with? 'ds'
      if line =~ /ds\s+(("[^"]*")|('[^"]*'))/
        parts = line.rpartition(/("[^"]*")|('[^']*')/)
        if parts[0] == ""
          error(line, "Could not find a string accompanying ds")
        end

        string = parts[1][1, parts[1].length-2] #remove quotes
        write_bytes(string.length + 1, 8)
        string.each_byte {|c|
          @output_bytes << c
        }
        @output_bytes << 0
      else
        if line.start_with? 'object' or line.start_with? 'function' or busy_object
          parts = line.split(' ')
          #reached the end of vars must now process busy_object
          if busy_object and parts[0] != 'ptr' and parts[0] != 'int'
            #align object defs to 16 bytes
            for i in (cur_byte)...(cur_byte/16.0).ceil*16
              if i % 2 == 0
                program[i] = 'dw 0'                             
              end
            end
            cur_byte = (cur_byte/16.0).ceil*16                  
            labels[busy_object[:name]] = cur_byte
            last_global_label = busy_object[:name]
            
            program[cur_byte] = "dq " + (busy_object.length - 1).to_s
            cur_byte += 8
            
            busy_object_keys.each_index {|i|
              k = busy_object_keys[i]
              obj_member_labels[busy_object[:name]+"."+k] = i
              #if i % 64 == 0 and i != 0
              #  program[cur_byte] = "dq #{bitmap}"
              #  cur_byte += 8
              #end
            }
            
            busy_object = nil
            busy_object_keys = []
          end
          if (parts[0] == 'object' or parts[0] == 'function') and not busy_object
            #create hash with :name keyword mapped to name of fn or object
            busy_object = {:name => parts[1]}
            puts ""
            puts "#{parts[0]} #{parts[1]}"
            #create empty array for variable names in order
            busy_object_keys = []
            next
          elsif parts[0] == 'ptr' or parts[0] == 'int' and busy_object
            #add names of vars to hash with mapping from name to type
            busy_object[parts[1]] = parts[0] 
            puts "  #{parts[1]}: #{parts[0]}"
            #store var names in order to index
            busy_object_keys << parts[1]
            next
          end
          @display_messages[@output_bytes.length] = "  imm: #{argument}"
          @fixups << Fixup.new(start_address, @output_bytes.length, argument)

          @output_bytes << 0
          @output_bytes << 0
        end
      when :immptr64
        if is_int? argument
          argument = Integer(argument)
          @display_messages[@output_bytes.length] = "  imm: &#{argument}"
          if not @constants.include? argument
            @constants << argument
          end
          
          if argument < 0
            label = "imm_m#{argument.abs}"
          else
            label = "imm_#{argument.abs}"
          end
        elsif line.start_with? 'ds'
          if line =~ /ds\s+(("[^"]*")|('[^"]*'))/
            parts = line.rpartition(/("[^"]*")|('[^']*')/)
            if parts[0]==""
              error line, "Could not find a string accompanying ds"
            end
            parts[1] = parts[1][1, parts[1].length-2]
            parts[1].each_byte {|c|
              program[cur_byte] = "db #{c}"
              cur_byte += 1
            }
          else
            error line, "Invalid syntax for ds"
          end
        elsif line.start_with? 'db'
          program[cur_byte] = line
          cur_byte += 1
        elsif line.start_with? 'dw'
          program[cur_byte] = line
          cur_byte += 2
        elsif line.start_with? 'dq'
          program[cur_byte] = line
          cur_byte += 8
        elsif line == 'align 8'
          for i in (cur_byte)...(cur_byte/8.0).ceil*8
            if i % 2 == 0
              program[i] = 'dw 0'
            end
          end
          
          label = "imm_#{argument.abs}"
          
          @fixups << Fixup.new(start_address, @output_bytes.length, label)

          @output_bytes << 0
          @output_bytes << 0
        elsif argument == '$'
          next_instr_immediates << @output_bytes.length
          @display_messages[@output_bytes.length] = "  imm: $"

          @output_bytes << 0
          @output_bytes << 0
        else
          parts=line.split(/[ ,\[\]]+/)
          puts " #{parts[0]} "+parts[1, parts.length-1].join(', ')
          instruction = $instructions.find {|inst| inst.opcode == parts[0]}
          if instruction == nil
            error line, "#{parts[0]} is not a valid instruction"
          end
          if not argument =~ /([a-zA-Z]\w*.)?[a-zA-Z]\w*/
            error(line, "Argument #{argument} is not valid")
          end
          last_index = 0
          instruction.operands.each_index {|index|
            last_index=index
            expected_operand = instruction.operands[index]
            operand = parts[index+1]
            if expected_operand == :immptr64
              if is_int? operand
                val = Integer(operand)
              elsif labels.has_key? operand
                val = labels[operand] - (cur_byte + 2)
              elsif operand == '$'
                val = 2*(parts.length - instruction.operands.count(:reg) - 1)
              elsif operand.start_with? "'"
                (val = operand[/'[^']'/][1, 1].ord) rescue error line, "#{operand} was recognised as a character literal, but failed to parse"
              else
                error line, "Couldn't make anything from #{operand}"
              end
              argument = @last_symbol + argument
            end
          }
          if instruction.operands[-1] == :arbimm16
            for index in (last_index+1)...parts.length
              operand = parts[index+1]
              if is_int? operand
                val = Integer(operand)
              elsif operand.start_with? "'"
                (val = operand[/'[^']'/][1, 1].ord) rescue error line, "#{operand} was recognised as a character literal, but failed to parse"
              else
                error line, "Couldn't make anything from #{operand}"
              end
              if const_labels.has_key? val
                label = const_labels[val]
              else
                label = "_imm_#{val.to_s.tr('-','m')}"
                const_labels[val] = label
                program_epilogue << "align 8"
                program_epilogue << "#{label}:"
                program_epilogue << "dq #{val}"
              end
              parts[index+1] = label
              line = parts[0]+" "+parts[1, parts.length-1].join(",")
            end
            @display_messages[@output_bytes.length] = "  imm: #{argument}"
            @fixups << Fixup.new(start_address, @output_bytes.length, argument)

            @output_bytes << 0
            @output_bytes << 0
          end
        end
      end
    } # end of all expected operands
    displacement = @output_bytes.length - start_address
    next_instr_immediates.each {|imm|
      @output_bytes[imm] = displacement & 0xFF
      @output_bytes[imm+1] = displacement >> 8
    }

    
    opcode = generate_opcode(instruction, reg_arguments, start_address)
    @output_bytes[start_address] = opcode & 0xFF
    @output_bytes[start_address+1] = opcode >> 8
  end

  def register_str(n)
    if USE_REAL_REG_NAMES
      $r[n]
    else
      "r#{n}"
    end
  end

  #instruction... has opcode which is a name
  #               has offset which is where the instruction is in terms of
  #               has_disallow_trivial between which is which regs cant be same

  #reg_arguments... is a list of arguments given to the current instruction
  def generate_opcode(instruction, reg_arguments, start_address)
    if USE_CONVENTIONAL_BYTECODE
      opcode = $instructions.index(instruction) << 9
      message = instruction.opcode + "(#{hex opcode}) "
      reg_arguments.each_with_index {|reg,i|
        opcode |= reg << (i*3)
        message += "#{register_str(reg)} "
      }
      @display_messages[start_address] = message
      return opcode
    else
      opcode = instruction.offset
      save_reg_count = reg_arguments.count
      
      if instruction.disallow_trivial_between.empty? #normal case => use matt's code
        message = instruction.opcode + "(#{hex opcode}) "
        reg_arguments.each_with_index {|reg,i|
          opcode += reg * (6**i)
          message += "#{register_str(reg)}(#{reg*(6**i)})"
        }
        
      else #do some kind of magic
        message = instruction.opcode + "begin magic" 
        #this code assumes the trivial case can only happen between 2 registers
        a = instruction.disallow_trivial_between[0]
        b = instruction.disallow_trivial_between[1]
        if reg_arguments[a] == reg_arguments[b]
          error inst, "Error - #{instruction.opcode} given illegal arguments "
        end
        reg_arguments[0, a + 1].each_index{|i|
          reg_arguments[i] *= (5.0/6.0)
        }
        extra = 0
        if reg_arguments[b] > reg_arguments[a]
          extra = -(6**(reg_arguments.length - b -1))
        end

        reg_arguments.each_index {|index|
          save_reg_count -= 1 #i dont remember why i do this :'(
          message += "#{((6**save_reg_count)*reg_arguments[index]).round}"
          opcode += ((6**save_reg_count)*reg_arguments[index]).round
        }
        opcode += extra

      end
      return opcode
    end
  end

  # At the end of the code, time to generate the constants section
  # and fill in the fixups
  def complete
    align(8)
    @constants.each {|constant|
      if constant < 0
        label = "imm_m#{constant.abs}"
      else
        label = "imm_#{constant.abs}"
      end
      
      add_label(label)
      @display_messages[@output_bytes.length] = "const #{constant}"
      write_bytes(constant, 8)
    }

    @fixups.each {|fixup|
      if not @abs_symbols.has_key? fixup.name
        error(fixup.name, "Symbol #{fixup.name} does not exist")
      end
      if @fake_symbols.include? fixup.name
        offset = @abs_symbols[fixup.name]
      else
        offset = @abs_symbols[fixup.name] - fixup.instr_base_addr
      end

      @output_bytes[fixup.fixup_addr] = offset & 0xFF
      @output_bytes[fixup.fixup_addr+1] = offset >> 8
    }
  end

  def render
    @output_bytes.pack('C*')
  end

  def display
    for i in 0...(@output_bytes.length-1)
      next if i % 2 != 0

      if parts[0] == 'db'
        (literal = Integer(parts[1])) rescue error instr, "Couldn't coerce #{parts[1]} into a number"
        if literal >= 0
          error instr, "Constant #{literal} too big for 8 bit int" if (literal>>8)!=0
        else
          error instr, "Constant #{literal} too big for 8 bit int" if (~(literal>>16))!=0
        end
        puts "#{(code.length*2).to_s(16)}: ".rjust(4)+"     (db #{literal})"
        code << literal
      elsif parts[0] == 'dw'
        (literal = Integer(parts[1])) rescue error instr, "Couldn't coerce #{parts[1]} into a number"
        if literal >= 0
          error instr, "Constant #{literal} too big for 16 bit" if (literal>>16)!=0
        else
          error instr, "Constant #{literal} too big for 16 bit" if (~(literal>>16))!=0
        end
        puts "#{(code.length*2).to_s(16)}: ".rjust(4)+"     (dw #{literal})"
        code << literal
      elsif parts[0] == 'dq'
        (literal = Integer(parts[1])) rescue error instr, "Couldn't coerce #{parts[1]} into a number"
        if literal >= 0
          error instr, "Constant #{literal} too big for 64 bit" if (literal>>64)!=0
        else
          error instr, "Constant #{literal} too big for 64 bit" if (~(literal>>64))!=0
        end
        puts "#{(code.length*2).to_s(16)}: ".rjust(4)+"     (dq #{literal})"
        #MSB first 
        code << (literal&0xFFFF)
        code << ((literal>>16)&0xFFFF)
        code << ((literal>>32)&0xFFFF)
        code << ((literal>>48)&0xFFFF)
      else
        instruction = $instructions.find {|inst| inst.opcode == parts[0]}
        error instr, "No such instruction '#{parts[0]}'" unless instruction
        
        @abs_symbols.each {|name, addr|
          if addr == i and not @fake_symbols.include? name
            puts "#{name}:"
          end
        }
      end
      
      word = (@output_bytes[i+1] << 8)|@output_bytes[i]
      print "  #{hex i}: #{hex word} "
      if @display_messages.has_key? i
        print "- #{@display_messages[i]}"
        if @display_messages.has_key? (i+1)
          puts ", #{@display_messages[i]}"
        else
          puts ""
        end
        if conventional
          code << (instruction.conventional_offset << 9)
        else
          code << instruction.offset
        end
        
        instruction_end = code.length*2
        last_index = 0
        reg_count = 0
        save_registers = []
        reg_val = 0
        immcount = 0
        instruction.operands.each_index do |index|
          last_index = index
          expected_operand = instruction.operands[index]
          operand = parts[index+1]
          
          if expected_operand == :reg
            if (operand.start_with? 'r') or (operand.start_with? 'p')
              reg = operand[1,operand.length-1].to_i
              reg_text = if real_reg then $r[reg] else "r#{reg}" end
              
              if conventional
                reg_val = reg << 3*reg_count
              else
                save_registers << reg
                if instruction.operands[index+1] != :reg
                  save_reg_count = save_registers.count
                  
                  if instruction.disallow_trivial_between.empty?
                    save_registers.each_index {|index|
                      save_reg_count -= 1
                      reg_val += (6**save_reg_count)*save_registers[index]
                    }
                  else
                    #this code assumes the trivial case can only happen between 2 registers
                    a = instruction.disallow_trivial_between[0]
                    b = instruction.disallow_trivial_between[1]
                    if save_registers[a] == save_registers[b]
                      error inst, "Error - #{instruction.opcode} given illegal arguments "
                    end
                    save_registers[0, a + 1].each_index{|i|
                      save_registers[i] *= (5.0/6.0)
                    }
                    extra = 0
                    if save_registers[b] > save_registers[a]
                      extra = -(6**(save_registers.length - b -1))
                    end

                    if (!conventional)
                      save_registers.each_index {|index|
                        save_reg_count -= 1
                        reg_val += ((6**save_reg_count)*save_registers[index]).round
                      }
                      reg_val += extra
                    end
                  end
                end
              end
              if instruction.operands[index+1] == :reg
                if conventional
                  print " +#{bin reg_val}(#{reg_text})"
                else
                  print " +#{reg_val}(#{reg_text})"
                end
              else
                if conventional
                  puts " +#{bin reg_val}(#{reg_text})"
                else
                  puts " +#{reg_val}(#{reg_text})"
                end
              end

              instruction_index = instruction_end/2 - 1 
              code[instruction_index] += reg_val
              
              reg_count += 1
            else
              error instr, "#{instruction.opcode} expects a register in position #{index+1}"
            end
          elsif (expected_operand == :imm16) || (expected_operand == :immptr64)
            immcount += 1
            if operand.start_with? '.'
              error instr, "Local #{operand} with no parent" unless last_global_label
              operand = last_global_label+operand
            end
            if labels.has_key? operand
              imm = ((labels[operand]) - instruction_end)/2 + 1
              #              puts "#{(instruction_end + imm).to_s(16)}"
              puts "#{(code.length*2).to_s(16)}: ".rjust(4)+(hex imm)+" (lbl: #{parts[index+1]})"
            elsif operand == '$'
              error instr, "No next instruction" if next_addr.nil?
              imm = ((next_addr) - instruction_end)/2 + 1
              puts "#{(code.length*2).to_s(16)}: ".rjust(4)+(hex imm)+" ($)"
            elsif (operand.start_with? '[') && (operand.end_with? ']')
              imm = Integer(operand[1, operand.length-2])
              puts "#{(code.length*2).to_s(16)}: ".rjust(4)+(hex imm)+" (ptr)"
            elsif expected_operand == :imm16
              if obj_member_labels.has_key? operand
                imm = obj_member_labels[operand]
              else
                (imm = Integer(operand)) rescue error instr, "Couldn't coerce '#{operand}' into a number - possible invalid label?"
              end
              puts "#{(code.length*2).to_s(16)}: ".rjust(4)+"#{imm}".rjust(4)+" (const)"
            else
              error instr, "Couldn't make anything from #{operand}"
            end
            code << imm
          end
          if instruction.operands[-1] == :arbimm16
            immcount += 1
            for index in (last_index+1)...parts.length
              operand = parts[index+1]
              if labels.has_key? operand
                if operand.start_with? '.'
                  error instr, "Local #{operand} with no parent" unless last_local_label
                  operand = last_local_label+operand
                end
                imm = labels[operand] - instruction_end
                puts "#{(code.length*2).to_s(16)}: ".rjust(4)+(hex imm)+" (lbl: #{parts[index+1]})"
              elsif operand == '$'
                error instr, "No next instruction" if next_addr.nil?
                imm = next_addr - instruction_end
              elsif (operand.start_with? '[') && (operand.end_with? ']')
                imm = Integer(operand[1, operand.length-2])
                puts "#{(code.length*2).to_s(16)}: ".rjust(4)+(hex imm)+" (ptr)"
              elsif expected_operand == :imm16
                (imm = Integer(operand)) rescue error instr, "Couldn't coerce #{operand} into a number - possible invalid label?"
                puts "#{(code.length*2).to_s(16)}: ".rjust(4)+"#{imm}".rjust(4)+" (const)"
              else
                error instr, "Couldn't make anything from #{operand}"
              end
              code << imm
            end
          end
        end
      end
    end
  end
end

def process_file(file, program)
  while not file.eof?
    line = file.peek

    if line.start_with? '%include '
      parts = file.readline.split(' ')
      BetterFile.open(File.dirname(file.path)+'/'+parts[1], 'r') {|f| process_file(f, program)}
    elsif line.end_with? ':'
      program.parse_label(file)
    elsif line.start_with? 'object '
      program.parse_object(file)
    elsif line.start_with? 'function '
      program.parse_function(file)
    elsif line.start_with?('db ', 'dw ', 'dq ', 'ds ')
      program.parse_constant(file)
    elsif line.start_with? 'align '
      program.parse_align(file)
    elsif line == ''
      file.readline
      next
    elsif line == nil
      break #end of file
    else
      program.parse_instruction(file)
    end
  end
end

if ARGV_WITHOUT_FLAGS[0] == nil
  puts "Matt's assembler"
  puts ""
  puts "Invocation:"
  puts " assembler.rb input_file [output_file] [-r -c]"
  puts ""
  puts " output_file defaults to a.out"
  puts " -r flag prints the names of the actual registers used in x64,"
  puts "   to make debugging a little easier."
  puts " -c flag generates code in the more conventional bytecode format"
  puts "   defined by Douglas:"
  puts "    bits  |  meaning"
  puts "   --------------------"
  puts "    0..2  |  register 3"
  puts "    3..5  |  register 2"
  puts "    6..8  |  register 1"
  puts "    9..16 |  opcode"
else
  program = Program.new
  file = BetterFile.open(ARGV_WITHOUT_FLAGS[0], 'r')
  process_file(file, program)
  file.close
  program.complete

  if ARGV_WITHOUT_FLAGS[1] == nil
    output_filename = "a.out"
  else
    output_filename = ARGV_WITHOUT_FLAGS[1]
  end
  program.display
  puts ""
  puts "Output:"
  puts "="*8
  program.display_raw
  IO.write(output_filename, program.render)
end
