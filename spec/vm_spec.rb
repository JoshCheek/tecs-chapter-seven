require 'vm'

shared_examples 'vm comparable' do |attribute|
  it 'must be the same class and have the same attribute' do
    described_class.new(12).should == described_class.new(12)
    described_class.new(12).should_not == described_class.new(13)
    described_class.new(12).should_not == Struct.new(attribute).new(12)
  end
end

module VM
  %w[Eq Lt Gt Add Sub Neg And Not Or].each do |klass_name|
    klass = Command.const_get klass_name

    describe klass do
      it 'is a kind of ArithmeticOperation' do
        klass.should be_a_kind_of ArithmeticOperation
      end

      it 'inspects to its name' do
        klass.inspect.should == klass_name
      end
    end
  end

  describe Command::Push do
    it_behaves_like "vm comparable", :to_push
  end

  describe Command::Pop do
    it_behaves_like "vm comparable", :to_pop
  end

  describe Constant do
    it_behaves_like "vm comparable", :value
  end

  shared_examples 'a reference' do
    it_behaves_like "vm comparable", :offset
    it 'inherits from Reference' do
      described_class.should < Reference
    end
  end

  shared_examples 'a virtual reference' do
    it_behaves_like 'vm comparable', :offset
    it 'inherits from VirtualReference' do
      described_class.should < VirtualReference
    end
  end

  [Pointer, Temp].each do |klass|
    describe klass do
      it_behaves_like "a virtual reference"
    end
  end

  [Local, Argument, This, That, Static].each do |klass|
    describe klass do
      it_behaves_like "a reference"
    end
  end
end
