class Inst
  attr_accessor :opcode #mnemonic
  attr_accessor :disallow_trivial_between #[0,1] means between reg argument 0 and reg argument 1
  attr_accessor :operands # a list of symbols - :reg, :imm16, :immptr64, :arbimm16
  attr_accessor :offset
  attr_accessor :conventional_offset

  def initialize(opcode, operands, disallow_trivial_between=[])
    @opcode = opcode
    @operands = operands
    @disallow_trivial_between = disallow_trivial_between
  end

  def allowed? (*r)
    check = []
    @disallow_trivial_between.each {|i| check << r[i]}
    not (check.any? {|item| check.count(item) > 1})
  end
end

instructions = []

#instructions with no operands
instructions +=
  ['ret','err']
  .collect {|opcode| Inst.new opcode, []}

#instructions with just one operand (register)
instructions +=
  ['in', 'out', 'null', 'print']
  .collect {|opcode| Inst.new opcode, [:reg]}

#instructions with just one operand (immediate)
instructions +=
  ['jmp']
  .collect {|opcode| Inst.new opcode, [:imm16]}

instructions +=
  ['jmpf']
  .collect {|opcode| Inst.new opcode, [:immptr64]}

#instructions with two registers only where the trivial case is allowed
instructions +=
  ['add','mul']
  .collect {|opcode| Inst.new opcode, [:reg, :reg]}

#instructions with two registers where the trivial case is disallowed
instructions +=
  ['sub','div','and','or','xor','shl','shr','sar','mov','newb','newo']
  .collect {|opcode| Inst.new opcode, [:reg, :reg], [0,1]}

#instructions with one register and one 16b immediate
instructions +=
  ['addc','mulc','divc','andc','orc','movc']
  .collect {|opcode| Inst.new opcode, [:reg, :immptr64]}

instructions +=
  ['shlc','shrc','sarc','getl', 'movsc']
  .collect {|opcode| Inst.new opcode, [:reg, :imm16]}

#instructions with one ptr and one register
instructions +=
  ['csub','cshl','cshr','csar']
  .collect {|opcode| Inst.new opcode, [:immptr64, :reg]}

instructions +=
  ['setl']
  .collect {|opcode| Inst.new opcode, [:imm16, :reg]}

#Three-operand instructions

instructions +=
  ['getb', 'geto']
  .collect {|opcode| Inst.new opcode, [:reg, :reg, :reg], [1,2]}

instructions +=
  ['setb', 'seto']
  .collect {|opcode| Inst.new opcode, [:reg, :reg, :reg], [0,1]}

#strange instructions
instructions +=
  ['swtch']
  .collect {|opcode| Inst.new opcode, [:reg, :imm16, :arbimm16]}

instructions +=
  ['jcmp']
  .collect {|opcode| Inst.new opcode, [:reg, :reg, :imm16, :imm16, :imm16], [0,1]}

instructions +=
  ['jcmpc']
  .collect {|opcode| Inst.new opcode, [:reg, :immptr64, :imm16, :imm16, :imm16]}

instructions +=
  ['jnullp']
  .collect {|opcode| Inst.new opcode, [:reg, :imm16, :imm16]}

instructions +=
  ['call']
  .collect {|opcode| Inst.new opcode, [:imm16, :imm16, :imm16]}

offsets =
  {
    'add' => 0,
    'addc' => 36,
    'sub' => 42,
    'csub' => 72,
    'mul' => 78,
    'mulc' => 114,
    'div' => 120,
    'divc' => 150,
    'and' => 156,
    'andc' => 186,
    'or' => 192,
    'orc' => 222,
    'xor' => 228,
    'shl' => 258,
    'shlc' => 288,
    'cshl' => 294,
    'shr' => 300,
    'shrc' => 330,
    'cshr' => 336,
    'sar' => 342,
    'sarc' => 372,
    'csar' => 378,
    'mov' => 384,
    'movc' => 414,
    'null' => 420,
    'getl' => 426,
    'setl' => 432,
    'geto' => 438,
    'seto' => 618,
    'getb' => 798,
    'setb' => 978,
    'jmp' => 1158,
    'jmpf' => 1159,
    'swtch' => 1160,
    'jcmp' => 1166,
    'jcmpc' => 1196,
    'jnullp' => 1202,
    'call' => 1208,
    'ret' => 1209,
    'newo' => 1210,
    'newb' => 1240,
    'movsc' => 1270,
    'err' => 1276,
    'in' => 1277,
    'out' => 1283,
    'print' => 1289
  }

# Yeah this is bad but it is still the nicest way
def is_int? str
  Integer(str) rescue return false
  return true
end

instructions.each {|instruction|
  instruction.offset = offsets[instruction.opcode]
#  puts instruction.opcode
#  puts instruction.offset
}

# Sort instructions by their numbers
instructions.sort_by! {|instruction| instruction.offset }

#instructions.each_index {|i| instructions[i].conventional_offset = i}

# Validate instructions
instructions.each {|instruction|
  raise "#{instruction.opcode} has no offset defined!" unless instruction.offset
}
offsets.each {|k,v|
  raise "#{k} has no instruction object" unless instructions.any? {|instr| instr.opcode == k}
}

# Register Mapping
r = {
  0 => 'rbx',
  1 => 'rcx',
  2 => 'rdx',
  3 => 'r8',
  4 => 'r9',
  5 => 'r10',
  'pc' => 'rsi',
  :fp => 'rbp'
}


# Export these variables
$instructions = instructions
$offsets = offsets
$r = r
