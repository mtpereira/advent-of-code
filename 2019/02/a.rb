require "./lib/intcode"

def input
  integers = ""
  ARGF.each_line do |line|
    integers = line.split(",").map(&:to_i)
    integers[1] = 12
    integers[2] = 2
  end
  integers
end

puts Intcode.new.run(input)[0]
