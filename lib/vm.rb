module VM
  class ArithmeticOperation
    attr_accessor :name

    def initialize(name)
      self.name = name
    end

    def inspect
      name.dup
    end

    def to_s
      inspect.downcase
    end

    alias === ==
  end


  class VirtualReference
    attr_accessor :offset

    def initialize(offset)
      self.offset = offset
    end

    def ==(other)
      self.class == other.class && offset == other.offset
    end

    def to_s
      "#{self.class.name[/:([^:]*$)/, 1].downcase} #{offset}"
    end
  end


  class Reference
    attr_accessor :offset

    def initialize(offset)
      self.offset = offset
    end

    def ==(other)
      self.class == other.class && offset == other.offset
    end

    def to_s
      "#{self.class.name[/:([^:]*$)/, 1].downcase} #{offset}"
    end
  end


  module Command
    extend Enumerable

    def self.each
      return to_enum :each unless block_given?
      constants.each { |name| yield const_get name }
    end

    Setup = Class.new do
      def self.to_s
        'Initalize the stack pointer'
      end
    end

    Eq  = ArithmeticOperation.new 'Eq'
    Lt  = ArithmeticOperation.new 'Lt'
    Gt  = ArithmeticOperation.new 'Gt'
    Add = ArithmeticOperation.new 'Add'
    Sub = ArithmeticOperation.new 'Sub'
    Neg = ArithmeticOperation.new 'Neg'
    And = ArithmeticOperation.new 'And'
    Not = ArithmeticOperation.new 'Not'
    Or  = ArithmeticOperation.new 'Or'

    class Push
      attr_accessor :to_push
      def initialize(to_push)
        self.to_push = to_push
      end

      def ==(other)
        self.class == other.class && to_push == other.to_push
      end

      def to_s
        "push #{to_push}"
      end
    end

    class Pop
      attr_accessor :to_pop
      def initialize(to_pop)
        self.to_pop = to_pop
      end

      def ==(other)
        self.class == other.class && to_pop == other.to_pop
      end

      def to_s
        "pop #{to_pop}"
      end
    end
  end

  class Constant
    attr_accessor :value
    def initialize(value)
      self.value = value
    end

    def ==(other)
      self.class == other.class && value == other.value
    end

    def to_s
      "constant #{value}"
    end
  end

  Pointer = Class.new VirtualReference
  Temp    = Class.new VirtualReference

  Local    = Class.new Reference
  Argument = Class.new Reference
  This     = Class.new Reference
  That     = Class.new Reference
  Static   = Class.new Reference

end
