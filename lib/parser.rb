require 'vm'

class Parser
  attr_accessor :source_lines

  def initialize(code)
    self.source_lines = code.each_line
  end

  def commands
    return to_enum :commands unless block_given?
    source_lines.each do |line|
      fuck_comments_in line
      line.strip!
      next if line.empty?
      yield interpret_line line
    end
  end

  def interpret_line(line)
    case line
    when "eq"         then VM::Command::Eq
    when "lt"         then VM::Command::Lt
    when "gt"         then VM::Command::Gt
    when "add"        then VM::Command::Add
    when "sub"        then VM::Command::Sub
    when "neg"        then VM::Command::Neg
    when "and"        then VM::Command::And
    when "not"        then VM::Command::Not
    when "or"         then VM::Command::Or
    when /^label/     then VM::Command::Label.new line.sub(/^label\s+/, '')
    when /^push/      then VM::Command::Push.new value_for line.sub(/^push\s+/, '')
    when /^pop/       then VM::Command::Pop.new value_for line.sub(/^pop\s+/, '')
    when /^goto/      then VM::Command::Goto.new line.sub(/^goto\s+/, '')
    when /^if-goto/   then VM::Command::IfGoto.new line.sub(/^if-goto\s+/, '')
    when /^function/  then parse_function line.sub(/^function\s+/, '')
    when "return"     then VM::Command::Return.new
    when /^call/      then parse_call line.sub(/^call\s+/, '')
    when "BREAKPOINT" then VM::Command::Breakpoint.new
    else
      raise "WTF is #{line.inspect}?"
    end
  end

  def parse_call(text)
    function_name, argument_count = text.split
    VM::Command::Call.new(function_name, argument_count.to_i)
  end

  def parse_function(text)
    name, locals_count = text.split
    VM::Command::Function.new(name, locals_count.to_i)
  end

  def value_for(line)
    self.class.value_for(line)
  end

  def self.value_for(line)
    allowed_values = %w[argument local static constant this that pointer temp]
    raise "WTF is #{line.inspect}" unless allowed_values.include? line.split.first
    class_name = line.split.first.capitalize
    VM.const_get(class_name).new Integer line[/-?\d+/]
  end

  def fuck_comments_in(line)
    line.sub! /\/\/.*$/, ''
  end
end
