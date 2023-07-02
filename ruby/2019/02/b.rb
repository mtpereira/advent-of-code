require "./lib/intcode"

def input
  integers = []
  ARGF.each_line do |line|
    integers = line.split(",").map(&:to_i)
  end
  integers
end

def calculate_inputs(program)
  (0..99).each do |noun|
    (0..99).each do |verb|
      modified_program = program.map(&:clone)
      modified_program[1, 2] = noun, verb

      result = Intcode.new.run(modified_program)[0]
      if result == 19690720
        return "#{noun}#{verb}"
      end

      return nil
    end
  end
end

puts calculate_inputs(input)
