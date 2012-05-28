require 'code_generator'

describe CodeGenerator do
  let(:commands)  { [VM::Command::Eq, VM::Command::Not] }
  let(:generator) { described_class.new commands }

  describe '#each_command' do
    it 'first yields the setup' do
      generator.each_command.first.should == VM::Command::Setup
    end

    it 'then yields the provided instructions' do
      generator.each_command.drop(1).should == commands
    end
  end

  describe '#each_instruction' do
    it 'yields the instructions associated with the commands, one at a time' do
      generator.each_instruction.to_a.should be_all { |instruction| instruction.kind_of? String }
    end

    it 'returns instructions for all the commands' do
      %w[Eq Lt Gt Add Sub Neg And Not Or].each do |name|
        command = VM::Command.const_get name
        generator.instructions_for(command).should be_a_kind_of Array
      end
      command = VM::Command::Push.new(VM::Constant.new 17)
      generator.instructions_for(command).should be_a_kind_of Array

      command = VM::Command::Pop.new(VM::Pointer.new 17)
      generator.instructions_for(command).should be_a_kind_of Array
    end

    it "raises errors for commands it doesn't know" do
      expect { generator.instructions_for 123 }.to raise_error
    end
  end
end
