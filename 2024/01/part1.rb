#!/usr/bin/env ruby

INPUT = "./input.txt".freeze
list1, list2 = [], []
distance = 0

File.open(INPUT) do |input|
  input.each do |line|
    col1, col2 = *line.chomp.split
    list1 += [col1.to_i]
    list2 += [col2.to_i]
  end
end

list1.sort!
list2.sort!

list1.each_index do |i|
  distance += (list1[i] - list2[i]).abs
end

puts distance
