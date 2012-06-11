module VM

  def self.compare_by(klass, *variables)
    klass.class_eval do
      attr_accessor *variables

      define_method :== do |other|
        self.class == other.class &&
          variables.map { |variable| self.send  variable } ==
          variables.map { |variable| other.send variable }
      end

      define_method :initialize do |*values|
        variables.zip(values).each { |variable, value| send "#{variable}=", value }
      end
    end
  end

  class ArithmeticOperation
    VM.compare_by self, :name

    def inspect
      name.dup
    end

    def to_s
      inspect.downcase
    end

    alias === == # can we remove this?
  end


  class VirtualReference
    VM.compare_by self, :offset

    def to_s
      "#{self.class.name[/:([^:]*$)/, 1].downcase} #{offset}"
    end
  end


  class Reference
    VM.compare_by self, :offset

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

    class Setup
      VM.compare_by self

      def self.to_s
        'Initalize the stack pointer'
      end
    end

    SetupWithInit    = Class.new Setup
    SetupWithoutInit = Class.new Setup

    Eq  = ArithmeticOperation.new 'Eq'
    Lt  = ArithmeticOperation.new 'Lt'
    Gt  = ArithmeticOperation.new 'Gt'
    Add = ArithmeticOperation.new 'Add'
    Sub = ArithmeticOperation.new 'Sub'
    Neg = ArithmeticOperation.new 'Neg'
    And = ArithmeticOperation.new 'And'
    Not = ArithmeticOperation.new 'Not'
    Or  = ArithmeticOperation.new 'Or'

    class Return
      VM.compare_by self

      def to_s
        'ALL HANDS, STANDBY FOR JUMP'
      end
    end

    class Breakpoint
      VM.compare_by self

      def to_s
        'BREAKPOINT'
      end
    end

    class Function < Struct.new(:name, :locals_count)
      Classless = Class.new do
        def ==(other)
          false
        end
      end

      def klass
        name[/^(.+)\..*/, 1] || Classless.new
      end
    end

    Label      = Struct.new :name
    Goto       = Struct.new :label
    IfGoto     = Struct.new :label
    Call       = Struct.new :function_name, :argument_count

    class Push
      VM.compare_by self, :to_push

      def to_s
        "push #{to_push}"
      end
    end

    class Pop
      VM.compare_by self, :to_pop

      def to_s
        "pop #{to_pop}"
      end
    end
  end

  class Constant
    VM.compare_by self, :value
    def to_s
      "constant #{value}"
    end
  end

  Pointer = Class.new VirtualReference
  Temp    = Class.new VirtualReference
  Static  = Class.new VirtualReference

  Local    = Class.new Reference
  Argument = Class.new Reference
  This     = Class.new Reference
  That     = Class.new Reference
end
