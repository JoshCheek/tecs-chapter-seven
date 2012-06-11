require 'vm'

class CodeGenerator
  attr_accessor :unique_label_counter, :context

  def initialize(commands)
    self.commands = commands
    self.unique_label_counter = 0
    self.context = GeneratorContext.new
  end

  def each_instruction(&block)
    return to_enum :each_instruction unless block_given?
    each_command do |command|
      context.register_command command
      block.call "// === #{command}"
      instructions_for(command).each(&block)
      block.call ""
    end
  end

  def each_command(&block)
    return to_enum :each_command unless block_given?
    yield context.setup_for commands
    commands.each(&block)
  end

  def instructions_for(command)
    case command
    when Breakpoint
      ['@9999']
    when SetupWithoutInit
      ['@256', 'D = A', '@SP', 'M = D'] # init SP
    when SetupWithInit
      ['@256', 'D = A', '@SP', 'M = D', # init SP
       *instructions_for(VM::Command::Call.new(context.init_function, 0))]
    when VM::ArithmeticOperation
      arithmetic(command)
    when Push
      get_value(command.to_push) +
      ['@SP // Place the value in D at the top of the stack', 'A = M', 'M = D'] +
      increment_stack_pointer
    when Pop
      [*decrement_stack_pointer, '@SP', 'A = M', 'D = M', *put_value(command.to_pop)]
    when Label
      ["(#{context.label_for command.name})"]
    when Goto
      ["@#{context.label_for command.label}", '0;JMP']
    when IfGoto
      [*pop_to_d, "@#{context.label_for command.label}", "D;JNE"]
    when Call
      return_address = context.unique_label "RETURN_FROM_#{command.function_name}"
      [ "@#{return_address} // Push the label", "D = A", *push_d,
        "@LCL // Push LCL", 'D = M', *push_d,
        "@ARG // Push ARG", 'D = M', *push_d,
        "@THIS // Push THIS", 'D = M', *push_d,
        "@THAT // Push THAT", 'D = M', *push_d,
        "@#{command.argument_count + 5} // ARG=SP-n-5", "D = A", "@SP", "D = M - D", "@ARG", "M = D",
        "@SP // LCL = SP", "D = M", "@LCL", "M = D", # LCL=SP
        "@#{command.function_name} // It's a leap of faith.", "0;JMP",
        "(#{return_address})", # declare label
      ]
    when Function
      ["(#{command.name})", *push_constant(0, command.locals_count)]
    when Return
      [ "@LCL // LCL-1 -> pointer+1", "A = M - 1", "D = M", "@THAT", "M = D",
        "@LCL // LCL-2 -> pointer+0", "A = M - 1", "A = A - 1", 'D = M', "@THIS", "M = D",
        "@3 // push saved ARG", "D = A", "@LCL", "A = M - D", "D = M", *push_d,
        "@5 // push return address", "D = A", "@LCL", "A = M - D", "D = M", *push_d,
        "@4 // restore LCL", "D = A", "@LCL", "A = M - D", "D = M", "@LCL", "M = D",
        '// move return_value to ARG', *decrement_stack_pointer(2), *pop_to_d, "@ARG", "A = M", "M = D", *increment_stack_pointer(3),
        '// move return address to ARG + 1', *pop_to_d, '@ARG', 'A = M + 1', 'M = D',
        '// move saved arg to ARG + 2', *pop_to_d, '@ARG', 'A = M + 1', 'A = A + 1', 'M = D',
        'D = A + 1 // stack pointer to ARG + 3', '@SP', 'M = D',
        '// restore saved_arg from sp-1 with pop', *pop_to_d, '@ARG', 'M = D',
        '// pop and return', *pop_to_d, 'A = D', '0;JMP // four... three... two... one... JUMP!',
      ]
    else
      raise "Don't know how to generate instructions for #{command.inspect}"
    end
  end

  private

  include VM::Command

  attr_accessor :commands

  def push_constant(value, times_to_push=1)
    ["@#{value}", "D = A", *times_to_push.times.map { push_d }.flatten]
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
    equal_label = context.unique_label "#{check}_SUCCESS"
    done_label  = context.unique_label "DONE"
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

  def increment_stack_pointer(times = 1)
    ['@SP // Increment stack pointer'] + ['M = M + 1'] * times
  end

  def decrement_stack_pointer(times = 1)
    ['@SP // Decremement stack pointer'] + ['M = M - 1'] * times
  end

  def base_address(value)
    context.base_address_for(value)
  end

  def load_stack_pointer(target = nil)
    result = ['@SP', 'A = M']
    result << "#{target} = M" if target
    result
  end

  def pop_to_d
    ['// Pop the top of the stack into D', *decrement_stack_pointer, *load_stack_pointer('D')]
  end

  def push_d
    [*load_stack_pointer, 'M = D', *increment_stack_pointer]
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
end
