require 'parser'

module VM

  describe ::Parser do

    def commands_for(string)
      described_class.new(string).commands.to_a
    end

    it 'parses empty lines as nothing' do
      commands_for("").should == []
      commands_for("\n\n\n").should == []
    end

    it 'parses comments as nothing' do
      commands_for("// Y helo thar").should == []
      commands_for(' // Y helo thar // mang').should == []
      commands_for('//abc\n//def\n').should == []
    end

    it 'removes comments from the ends of lines' do
      commands_for("eq //abc\neq//def").should == [Command::Eq, Command::Eq]
    end

    describe 'push commands' do
      it 'understands constants' do
        commands_for('push constant 17').should ==
          [Command::Push.new(Constant.new 17)]
        commands_for('push constant -17').should ==
          [Command::Push.new(Constant.new -17)]
      end

      it 'understands pointer' do
        commands_for("push pointer 0\npush pointer -1").should ==
          [Command::Push.new(Pointer.new 0), Command::Push.new(Pointer.new -1)]
      end

      it 'undertstands references' do
        commands_for("push this 1\n push local -5").should ==
          [Command::Push.new(This.new 1), Command::Push.new(Local.new -5)]
      end
    end

    describe 'pop commands' do
      it 'understands pointer' do
        commands_for("pop pointer 0\npop pointer -1").should ==
          [Command::Pop.new(Pointer.new 0), Command::Pop.new(Pointer.new -1)]
      end

      it 'undertstands references' do
        commands_for("pop this 1\n pop local 5").should ==
          [Command::Pop.new(This.new 1), Command::Pop.new(Local.new 5)]
      end
    end

    describe '.value_types' do
      %w[argument local static constant this that pointer temp].each do |value_type|
        it "identifies #{value_type}" do
          described_class.value_for(value_type + " 3").should be_a_kind_of VM.const_get(value_type.capitalize)
        end
      end

      it 'does not identify anything else' do
        expect { described_class.value_for 'push 1' }.to raise_error
      end
    end

    %w[eq lt gt add sub neg and not or].each do |command_name|
      it "parses the #{command_name} command" do
        commands_for(command_name).should == [VM::Command.const_get(command_name.capitalize)]
      end
    end

    # also shit with lots of lines
  end
end
