def safe?(numbers)
  previous = numbers.first
  previous_direction = 0
  result = true

  numbers.drop(1).each do |n|
    change = (previous - n)
    if change == 0 || change.abs > 3
      return false
    end

    begin
      direction = change / change.abs
    rescue ZeroDivisionError
      return false
    end

    direction_changed = previous_direction != direction
    if direction_changed && previous_direction != 0
      return false
    end

    previous_direction = direction
    previous = n
  end

  result
end

INPUT = "./input.txt".freeze
safe_count = 0

File.open(INPUT) do |f|
  f.each do |line|
    numbers = line.split.map(&:to_i)
    safe_count += 1 if safe?(numbers)
  end
end

puts safe_count
