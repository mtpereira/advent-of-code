class Intcode
  def run(code)
    return code if code.empty?

    output = code
    code.each_slice(4) do |i|
      return output if i[0] == OPCODE99

      instruction = Instruction.new(
        operator: get_operator(i[0]),
        args: deferred_args(i[1..2], code),
        store_address: i[3]
      )

      result = instruction.evaluate
      output[instruction.store_address] = result unless result.nil?
    end

    output
  end

  private

    OPCODE1 = 1
    OPCODE2 = 2
    OPCODE99 = 99

    def get_operator(opcode)
      case opcode
      when OPCODE1
        :+
      when OPCODE2
        :*
      else
        raise UnknownOpcode.new("#{opcode} is unknown")
      end
    end

    def deferred_args(args, code)
      [code[args[0]], code[args[1]]]
    end
end

class Instruction
  def initialize(operator:, args:, store_address:)
    @op = operator
    @first_arg, @second_arg = args
    @store_address = store_address
  end

  def evaluate
    [@first_arg, @second_arg].reduce(@op)
  end

  def store_address
    @store_address
  end
end

class UnknownOpcode < StandardError
end
