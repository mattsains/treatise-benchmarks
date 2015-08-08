#!/usr/bin/env ruby
require File.dirname(__FILE__)+'/instructions.rb'

real_reg = ARGV.include? '-r'
conventional = ARGV.include? '-c'
argv_without_flags = ARGV - ['-r', '-c']

program={}
program_epilogue=[]
const_labels={}
obj_member_labels={}

labels={}
last_global_label=nil
cur_byte=0

def hex n
  ("%04x"%n).tr('..','ff').reverse[0, 4].reverse
end

def bin n
  ("0b%b"%n)
end

def error line, msg
  puts "="*60
  puts "Error with '#{line}':"
  puts "  #{msg}"
  puts "="*60
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

    puts ""
    puts "Understood Code:"
    puts "================"

    busy_object = nil
    busy_object_keys = []

    #after this massive block,
    # f.each_line &process_line
    process_line = proc do |line|
      line = line.split(';')[0] #remove comments
      line.strip! #remove spaces

      next if line.empty? #skip empty lines

      if line.start_with? '%include'
        parts = line.split(' ')
        File.open(File.dirname(f.path)+'/'+parts[1],"r") do |f|
          f.each_line &process_line
        end
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
        end
        if line.end_with? ':'
          label = line.match(/\.?[^\d\W]\w*/)[0]
          puts "#{label}:"
          if label.start_with? '.'
            error line, "Local #{label} with no parent" unless last_global_label
            labels[last_global_label + label] = cur_byte
          else
            labels[label] = cur_byte
            last_global_label = label
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
          cur_byte = (cur_byte/8.0).ceil * 8
        else
          parts=line.split(/[ ,\[\]]+/)
          puts " #{parts[0]} "+parts[1, parts.length-1].join(', ')
          instruction = $instructions.find {|inst| inst.opcode == parts[0]}
          if instruction == nil
            error line, "#{parts[0]} is not a valid instruction"
          end
          if instruction.operands.length!=parts.length-1
            error line, "#{instruction.opcode} given wrong number of arguments "+
                        "(#{parts.length-1} for #{instruction.operands})"
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
          end
          
          program[cur_byte] = line
          cur_byte += 2*(parts.length - instruction.operands.count(:reg))
        end
      end
    end
    
    f.each_line &process_line
    
    program_epilogue.each {|line|
      #These can only have constants and labels
      if line.end_with? ':'
        label = line.match(/[^\d\W]\w*/)[0]
        labels[label] = cur_byte
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
        cur_byte = (cur_byte/8.0).ceil * 8
      else
        raise "Critical Error: #{line} - invalid data in program epilogue"
      end
    }
    puts ""
    puts "Symbol table:"
    puts "============="
    labels.each {|name, addr|
      puts "#{name}:".rjust(20)+addr.to_s(16).rjust(4)
    }
    
    puts ""
    puts "Code generation:"
    puts "================"

    code = []
    last_global_label = nil
    program.each {|addr,instr|
      _next = (program.select {|a,i| a > addr}) .min_by {|k,v| k}
      next_addr = _next.nil? ? nil :  _next[0]
      next_instr = _next.nil? ? nil : _next[1]
      parts=[]
      instr.split.each {|s| parts+=s.split(',')}
      
      labels.each {|k,v| puts "    #{k}:" if v==(code.length*2)}

      labels.each {|k,v| last_global_label = k if v==code.length*2 and not k.include? '.'} #don't care which

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
        
        if instruction.operands[0] == :reg
          if conventional
            print "#{(code.length*2).to_s(16)}: ".rjust(4)+(hex $instructions.index(instruction) << 9)+" (#{instruction.opcode})"
          else
            print "#{(code.length*2).to_s(16)}: ".rjust(4)+(hex instruction.offset)+" (#{instruction.opcode})"
          end
        else
          if conventional
            puts "#{(code.length*2).to_s(16)}: ".rjust(4)+(hex $instructions.index(instruction) << 9)+" (#{instruction.opcode})"
          else
            puts "#{(code.length*2).to_s(16)}: ".rjust(4)+(hex instruction.offset)+" (#{instruction.opcode})"
          end
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
    }

    if argv_without_flags[1] == nil
      filename = "a.out"
    else
      filename = argv_without_flags[1]
    end
    
    puts ""
    puts "Output:"
    puts "======="
    
    word_count=0
    print (hex 0)+": "
    code.each {|word|
      word_count+=1
      if word_count%4==0
        puts (hex word)
        print (hex word_count*2)+": " unless word_count==code.length
      else
        print (hex word)+" "
      end
    }
    puts ""
    puts ""
    IO.write(filename, code.pack('s*'))
  end
end
