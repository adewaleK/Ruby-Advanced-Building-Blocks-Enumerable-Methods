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

  def my_any?
    # Return true if no block is given
    return true unless block_given?

    boolean = false
    if self.class == Array
      my_each do |n|
        boolean = true if yield(n)
      end
    else
      my_each do |key, value|
        boolean = true if yield(key, value)
      end
    end
    boolean
  end

  def my_none?
    # Return false in case no block is provided
    return false unless block_given?

    boolean = true
    if self.class == Array
      my_each do |n|
        boolean = false if yield(n)
        break unless boolean
      end
    else
      my_each do |key, value|
        boolean = false if yield(key, value)
        break unless boolean
      end
    end
    boolean
  end

  def my_count(element = nil)
    counter = 0
    if block_given?
      if self.class == Array
        my_each do |n|
          counter += 1 if yield(n)
        end
      else
        my_each do |key, value|
          counter += 1 if yield(key, value)
        end
      end
    elsif !block_given? && element.nil?
      return length
    elsif !block_given? && !element.nil?
      my_each do |n|
        counter += 1 if n == element
      end
    end
    counter
  end

  def my_map
    # If no block is given, an enumerator is returned instead.
    return to_enum unless block_given?

    array = []
    if self.class == Array
      my_each do |n|
        array << yield(n)
      end
    else
      my_each do |key, value|
        array << yield(key, value)
      end
    end
    array
  end

  def my_inject(symbol = nil, initial_value = nil)
    if symbol.class != Symbol
      temp = symbol
      symbol = initial_value
      initial_value = temp
    end
    value_provided = false
    value_provided = true unless initial_value.nil?
    memo = initial_value || self[0]
    case symbol
    when :+
      if !value_provided
        drop(1).my_each do |n|
          memo += n
        end
      else
        my_each do |n|
          memo += n
        end
      end
    when :*
      if !value_provided
        drop(1).my_each do |n|
          memo *= n
        end
      else
        my_each do |n|
          memo *= n
        end
      end
    when :/
      if !value_provided
        drop(1).my_each do |n|
          memo /= n
        end
      else
        my_each do |n|
          memo /= n
        end
      end
    when :-
      if !value_provided
        drop(1).my_each do |n|
          memo -= n
        end
      else
        my_each do |n|
          memo -= n
        end
      end
    when :**
      if !value_provided
        drop(1).my_each do |n|
          memo **= n
        end
      else
        my_each do |n|
          memo **= n
        end
      end
    else
      drop(1).my_each do |n|
        memo = yield(memo, n)
      end
    end
    memo
  end

end

# Code used to test the methods compared with the original ones
array = [1, 2, 3]
hash = {a: 1, b: 2, c: 3}
array_of_words = %w[cat sheep bear]

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
# p array.all?
# p array.my_all?
#
# p array.all? { |n| n < 4 }
# p array.my_all? { |n| n < 4 }
#
# p hash.all? { |key, value| value < 4 }
# p hash.my_all? { |key, value| value < 4 }

# any? vs. my_any?
# p array.any?
# p array.my_any?
#
# p array.any? { |n| n == 4 }
# p array.my_any? { |n| n == 4 }
#
# p hash.any? {|key, value| key == :z}
# p hash.my_any? {|key, value| key == :z}

# none? vs. my_none?
# p array.none?
# p array.my_none?
#
# p array.none? { |n| n == 5 }
# p array.my_none? { |n| n == 5 }
#
# p hash.none? { |key, value| key == :c }
# p hash.none? { |key, value| key == :c}

# count? vs. my_count?
# p array.count
# p array.my_count
#
# p array.count(1)
# p array.my_count(1)
#
# p array.count { |n| n > 1 }
# p array.my_count { |n| n > 1 }
#
# p hash.count { |key, value| value % 2 != 0 }
# p hash.my_count { |key, value| value % 2 != 0 }

# map vs. my_map
# p array.map
# p array.my_map
#
# p array.map { |n| n * 10 }
# p array.my_map { |n| n * 10 }
#
# p hash.map { |key, value| [key, value] }
# p hash.my_map { |key, value| [key, value] }

# inject vs. my_inject
p array.inject(:-)
p array.my_inject(:-)

p array.inject { |memo, n| memo - n }
p array.my_inject { |memo, n| memo - n }

p array.inject(3, :-)
p array.my_inject(3, :-)

p array.inject(2) { |memo, n| memo * n }
p array.my_inject(2) { |memo, n| memo * n }

inject_test = array_of_words.inject do |memo, word|
  memo.length > word.length ? memo : word
end

p inject_test

my_inject_test = array_of_words.my_inject do |memo, word|
  memo.length > word.length ? memo : word
end

p my_inject_test