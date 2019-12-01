require_relative "lib"

puts(input.sum { |mass| fuel_needed_plus_fuel(mass) })
