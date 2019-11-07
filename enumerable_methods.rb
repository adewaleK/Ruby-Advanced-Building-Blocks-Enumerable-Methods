#!/usr/bin/env ruby
# frozen_string_literal: true

# This module contains an implementation of some of the methods found in the
# Enumerable module
module Enumerable

  def my_each
    # An enumerator is returned if no block is given
    return to_enum unless block_given?

    i = 0
    self_class = self.class
    array = self_class == Array ? self : flatten
    while i < array.length
      self_class == Array ? yield(array[i]) : yield(array[i], array[i + 1])
      i += self_class == Array ? 1 : 2
    end
  end

  def my_each_with_index
    # If no block is given, an enumerator is returned instead.
    return to_enum unless block_given?

    array = self.class == Array ? self : to_a
    i = 0
    while i < length
      yield(array[i], i)
      i += 1
    end
  end

  def my_select
    # If no block is given, an Enumerator is returned instead.
    return to_enum unless block_given?

    enumerable = self.class == Array ? [] : {}
    if enumerable.class == Array
      my_each do |n|
        enumerable.push(n) if yield(n)
      end
    else
      my_each do |key, value|
        enumerable[key] = value if yield(key, value)
      end
    end
    enumerable
  end

  def my_all?
    # Return true if no block is given
    return true unless block_given?

    boolean = true
    if self.class == Array
      my_each do |n|
        boolean = false unless yield(n)
      end
    else
      my_each do |key, value|
        boolean = false unless yield(key, value)
      end
    end
    boolean
  end

end

# Code used to test the methods compared with the original ones
array = [1, 2, 3]
hash = { a: 1, b: 2, c: 3 }

# "Tests"  for #my_each
# puts [1, 2, 3].each
# puts [1, 2, 3].my_each
#
# [1, 2, 3].each { |n| p n }
# [1, 2, 3].my_each { |n| p n }
#
# hash = {a: 1, b: 2, c: 3}
# hash.each { |key, value| puts "Key: #{key}, Value: #{value}" }
# hash.my_each { |key, value| puts "Key: #{key}, Value: #{value}" }

# "Tests" for #my_each_with_index
# array = [1, 2, 3]
#
# p array.each_with_index
# p array.my_each_with_index
#
# array.each_with_index do |element, index|
#   puts "Index: #{index}, Element:#{element}"
# end
# array.my_each_with_index do |element, index|
#   puts "Index: #{index}, Element:#{element}"
# end
#
# hash = {a: 1, b: 2, c: 3}
#
# hash.each_with_index do |element, index|
#   puts "Index: #{index}, Element: #{element}"
# end
# hash.my_each_with_index do |element, index|
#   puts "Index: #{index}, Element: #{element}"
# end

# select vs. my_select
# p array.select
# p array.my_select
#
# p array.select { |n| n % 2 == 1 }
# p array.my_select { |n| n % 2 == 1 }
#
# p hash.select {|key, value| value == 2}
# p hash.my_select { |key, value| value == 2}

# all? vs. my_all?
p array.all?
p array.my_all?

p array.all? { |n| n < 4 }
p array.my_all? { |n| n < 4 }

p hash.all? { |key, value| value < 4 }
p hash.my_all? { |key, value| value < 4 }
