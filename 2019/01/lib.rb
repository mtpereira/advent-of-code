def input
  ARGF.map(&:to_i)
end

def fuel_needed(mass)
  mass / 3 - 2
end

def fuel_needed_plus_fuel(mass, total_fuel=0)
  fuel = fuel_needed mass
  if fuel <= 0
    total_fuel
  else
    fuel_needed_plus_fuel(fuel, total_fuel + fuel)
  end
end
