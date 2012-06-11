require 'vm'
require 'generator_context'

describe GeneratorContext do
  let(:context) { GeneratorContext.new }

  describe '#init_function' do
    it 'returns Sys.init' do
      context.init_function.should == 'Sys.init'
    end
  end

  describe '#setup_for' do
    it 'returns a SetupWithoutInit when there is no init function' do
      context.setup_for([VM::Command::Function.new('NotSys.init', 1)]).should == VM::Command::SetupWithoutInit.new
    end

    it 'returns a SetupWithInit when there is an init function' do
      context.setup_for([VM::Command::Function.new('Sys.init', 1)]).should == VM::Command::SetupWithInit.new
    end
  end

  describe '#label_for' do
    it 'returns the label if it has not yet seen a function' do
      context.label_for('some_location').should == 'some_location'
    end

    it 'returns the function_name:label_name for the last function that it has seen' do
      context.register_command VM::Command::Function.new('fib', 1)
      context.label_for('loop').should == 'fib:loop'
      context.register_command VM::Command::Function.new('bif', 1)
      context.label_for('location').should == 'bif:location'
    end
  end

  describe '#unique_label' do
    it 'uses the label_name followed by an incrementing counter' do
      context.unique_label('abc').should == 'abc_1'
      context.unique_label('abc').should == 'abc_2'
    end
  end

  describe '#base_address_for' do
    context 'when reference is static' do
      def push(to_push)
        VM::Command::Push.new to_push
      end

      def pop(to_pop)
        VM::Command::Pop.new to_pop
      end

      def static(n)
        VM::Static.new(n)
      end

      def constant(n)
        VM::Constant.new(n)
      end

      def function(name)
        VM::Command::Function.new name, 0
      end

      # don't really know what to do if this happens before a function

      it 'returns 16 for all statics under the first function' do
        context.register_command(function 'first_function')
        context.register_command(push static 0)
        context.base_address_for(static 0).should == 16
        context.register_command(pop static 10)
        context.register_command(push constant 10)
        context.base_address_for(static 10).should == 16
      end

      it 'returns 16 + the largest static in functions (counting from zero), for each previous function' do
        context.register_command(function 'FUNCITON_1')
        context.register_command(push static 10)
        context.base_address_for(static 10).should == 16
        context.register_command(push static 0)
        context.base_address_for(static 0).should == 16

        context.register_command(function 'FUNCITON_2')
        context.register_command(push static 0)
        context.base_address_for(static 0).should == 27

        context.register_command(function 'FUNCITON_3')
        context.register_command(push static 0)
        context.base_address_for(static 0).should == 28
      end

      it 'remembers the offsets for previous functions' do
        context.register_command(function 'Class1.function1')
        context.register_command(push static 10)
        context.register_command(push static 10)

        context.register_command(function 'Class1.function2')
        context.register_command(push static 15)
        context.base_address_for(static 15).should == 16

        context.register_command(function 'FUNCITON_2')
        context.register_command(push static 0)
        context.base_address_for(static 0).should == 32
      end
    end

    [VM::Local, VM::Argument, VM::This, VM::That, VM::Pointer, VM::Temp].each do |reference_type|
      it "returns the integer base address for #{reference_type}" do
        context.base_address_for(reference_type.new(5)).should be_kind_of Fixnum
      end
    end

    it 'raises an error for anything it does not know' do
      expect { context.base_address_for nil }.to raise_error /Can't.*?nil/
    end
  end
end
