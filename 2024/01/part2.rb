#!/usr/bin/env ruby

INPUT = "./input.txt".freeze
count1, count2 = Hash.new(0), Hash.new(0)
similarity = 0

File.open(INPUT) do |input|
  input.each do |line|
    col1, col2 = *line.chomp.split
    count1[col1.to_i] += 1
    count2[col2.to_i] += 1
  end
end

puts count1

count1.each_key do |k|
  similarity += (k * count2[k])
end

puts similarity
