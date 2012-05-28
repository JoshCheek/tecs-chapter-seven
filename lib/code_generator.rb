require 'vm'

class CodeGenerator
  BASE_ADDRESSES = {
    VM::Local    => 1,
    VM::Argument => 2,
    VM::Pointer  => 3,
    VM::This     => 3,
    VM::That     => 4,
    VM::Temp     => 5,
    VM::Static   => 16
  }

  attr_accessor :unique_label_counter

  def initialize(commands)
    self.commands = commands
    self.unique_label_counter = 0
  end

  def each_command(&block)
    return to_enum :each_command unless block_given?
    yield VM::Command::Setup
    commands.each(&block)
  end

  def each_instruction(&block)
    return to_enum :each_instruction unless block_given?
    each_command do |command|
      block.call "// === #{command}"
      instructions_for(command).each(&block)
      block.call ""
    end
  end

  def instructions_for(command)
    if command == Setup
      ['@256', 'D = A', '@0', 'M = D']
    elsif command.kind_of? VM::ArithmeticOperation
      arithmetic(command)
    elsif command.kind_of? Push
      get_value(command.to_push) +
      ['@0 // Place the value in D at the top of the stack', 'A = M', 'M = D'] +
      increment_stack_pointer
    elsif command.kind_of? Pop
      [*decrement_stack_pointer, '@0', 'A = M', 'D = M', *put_value(command.to_pop)]
    else
      raise "Don't know how to generate instructions for #{command.inspect}"
    end
  end

  def get_value(value_type)
    case value_type
    when VM::Constant
      ['// Load constant into D', *load_immediate(value_type.value), 'D = A']
    when VM::VirtualReference
      address = base_address(value_type) + value_type.offset
      [ "@#{address} // Load the value of #{value_type.inspect} into D", 'D = M']
    when VM::Reference
      [ "@#{base_address(value_type)} // Load the value of #{value_type.inspect} into D",
        'A = M', 'D = A', "@#{value_type.offset}", 'A = A + D', 'D = M']
    end
  end

  def put_value(value_type)
    case value_type
    when VM::VirtualReference
      address = base_address(value_type) + value_type.offset
      ["@#{address}", 'M = D']
    when VM::Reference
      address = base_address(value_type)
      ["@#{address}", 'A = M', *value_type.offset.times.map { 'A = A + 1' }, 'M = D']
    end
  end

  def arithmetic(command)
    case command
    when Eq  then boolean 'EQ'
    when Lt  then boolean 'LT'
    when Gt  then boolean 'GT'
    when Add then binary  '+'
    when Sub then binary  '-'
    when And then binary  '&'
    when Or  then binary  '|'
    when Neg then unary   '-'
    when Not then unary   '!'
    end
  end

  def binary(operator)
    [*pop_to_d, *decrement_stack_pointer, *load_stack_pointer, "D = M #{operator} D", *push_d]
  end

  def unary(operator)
    [*pop_to_d, "D = #{operator}D", *push_d]
  end

  def boolean(check)
    equal_label = unique_label "#{check}_SUCCESS"
    done_label  = unique_label "DONE"
    [*pop_to_d,
     *decrement_stack_pointer,
     *load_stack_pointer,
     'D = M - D',
     "@#{equal_label}",
     "D;J#{check}",
     "D = #{false_value}",
     *push_d,
     "@#{done_label}",
     '0;JMP',
     "(#{equal_label})",
     "D = #{true_value}",
     *push_d,
     "(#{done_label})"]
  end

  def increment_stack_pointer
    ['@0 // Increment stack pointer', 'M = M + 1']
  end

  def decrement_stack_pointer
    ['@0 // Decremement stack pointer', 'M = M - 1']
  end

  def base_address(command)
    BASE_ADDRESSES[command.class]
  end

  def load_stack_pointer(target = nil)
    result = ['@0', 'A = M']
    result << "#{target} = M" if target
    result
  end

  def pop_to_d
    ['// Pop the top of the stack into D', *decrement_stack_pointer, *load_stack_pointer('D')]
  end

  def push_d
    [*load_stack_pointer, 'M = D', *increment_stack_pointer]
  end

  def unique_label(name)
    self.unique_label_counter += 1
    "#{name}_#{unique_label_counter}"
  end

  def true_value
    '-1'
  end

  def false_value
    '0'
  end

  # b/c their assembly interpreter can't load negative values -.-
  def load_immediate(num)
    return ["@#{num}"] if num > 0
    ["@#{num.abs}", "A = -A"]
  end

  include VM::Command

  attr_accessor :commands
end
