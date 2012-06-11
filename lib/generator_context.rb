class GeneratorContext
  BASE_ADDRESSES = {
    VM::Local    => 1,
    VM::Argument => 2,
    VM::Pointer  => 3,
    VM::This     => 3,
    VM::That     => 4,
    VM::Temp     => 5
  }

  attr_accessor :label_id, :maximum_static, :static_base

  def initialize
    self.label_id = 0
    self.static_base = 16
    self.maximum_static = 0
  end

  def base_address_for(value)
    return static_base if value.kind_of? VM::Static
    BASE_ADDRESSES.fetch value.class do
      raise "Can't find base address for #{value.inspect}"
    end
  end

  def unique_label(name)
    "#{name}_#{next_label_id}"
  end

  def label_for(name)
    if in_function?
      "#{current_function.name}:#{name}"
    else
      name
    end
  end

  def register_command(command)
    if command.kind_of?(VM::Command::Function) && current_function && command.klass != current_function.klass
      self.static_base += maximum_static
      self.maximum_static = 0
      self.current_function = command
    elsif command.kind_of? VM::Command::Function
      self.current_function = command
    elsif command.kind_of?(VM::Command::Push) && command.to_push.kind_of?(VM::Static)
      self.maximum_static = [self.maximum_static, command.to_push.offset.next].max
    elsif command.kind_of?(VM::Command::Pop) && command.to_pop.kind_of?(VM::Static)
      self.maximum_static = [self.maximum_static, command.to_pop.offset.next].max
    end
  end

  def setup_for(commands)
    if commands.any? { |command| command.kind_of?(VM::Command::Function) && command.name == init_function }
      VM::Command::SetupWithInit.new
    else
      VM::Command::SetupWithoutInit.new
    end
  end

  def init_function
    'Sys.init'
  end

  private

  attr_accessor :current_function

  def in_function?
    !!current_function
  end

  def next_label_id
    self.label_id += 1
  end
end
