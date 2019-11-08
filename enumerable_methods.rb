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
puts "\nBelow you will find the results of applying the original method vs. the
custom implementation."
puts
array = [1, 2, 3]
hash = { a: 1, b: 2, c: 3 }
array_of_words = %w[cat sheep bear]

puts 'We will use the following objects to check the outputs:'
puts
puts 'array = [1, 2, 3]'
puts 'hash = {a: 1, b: 2, c: 3}'
puts 'array_of_words = %w[cat sheep bear]'
puts

# "Tests"  for #my_each
puts '-' * 80
puts 'each vs. my_each'
puts '-' * 80
puts
puts 'array.each output: ' + array.each.to_s
puts 'array.my_each output: ' + array.my_each.to_s
puts
print 'array.each { |n| p n } output: '
array.each { |n| print n }
puts
print 'array.my_each { |n| n } output: '
array.my_each { |n| print n }
puts
puts
puts 'hash.each { |key, value| puts "Key: #{key}, Value: #{value}" } output:
'
hash.each { |key, value| puts "Key: #{key}, Value: #{value}" }
puts 'hash.my_each { |key, value| puts "Key: #{key}, Value: #{value}" } output:
'
hash.my_each { |key, value| puts "Key: #{key}, Value: #{value}" }
puts

# "Tests" for #my_each_with_index
puts '-' * 80
puts 'each_with_index vs. my_each_with_index'
puts '-' * 80
puts

puts 'array.each_with_index output: ' + array.each_with_index.to_s
puts 'array.my_each_with_index output: ' + array.my_each_with_index.to_s
puts
puts 'array.each_with_index do |element, index|
  puts "Index: #{index}, Element:#{element}"
end output: '
array.each_with_index do |element, index|
  puts "Index: #{index}, Element:#{element}"
end
puts 'array.my_each_with_index do |element, index|
  puts "Index: #{index}, Element:#{element}"
end output: '
array.my_each_with_index do |element, index|
  puts "Index: #{index}, Element:#{element}"
end
puts
puts 'hash.each_with_index do |element, index|
  puts "Index: #{index}, Element: #{element}"
end output: '
hash.each_with_index do |element, index|
  puts "Index: #{index}, Element: #{element}"
end
puts 'hash.my_each_with_index do |element, index|
  puts "Index: #{index}, Element: #{element}"
end output: '
hash.my_each_with_index do |element, index|
  puts "Index: #{index}, Element: #{element}"
end
puts

# select vs. my_select
puts '-' * 80
puts 'select vs. my_select'
puts '-' * 80
puts
puts 'array.select output: ' + array.select.to_s
puts 'array.my_select output: ' + array.my_select.to_s
puts
puts 'array.select(&:odd?) output: '
p array.select(&:odd?)
puts 'array.my_select(&:odd?) output: '
p array.my_select(&:odd?)
puts
puts 'hash.select { |key, value| value == 2 } output: '
p(hash.select { |_key, value| value == 2 })
puts 'hash.my_select { |key, value| value == 2 } output: '
p(hash.my_select { |_key, value| value == 2 })

# all? vs. my_all?
puts '-' * 80
puts 'all? vs. my_all?'
puts '-' * 80
puts
puts 'array.all? output: ' + array.all?.to_s
puts 'array.my_all? output: ' + array.my_all?.to_s
puts
puts 'array.all? { |n| n < 4 } output: '
p(array.all? { |n| n < 4 })
puts 'array.my_all? { |n| n < 4 } output: '
p(array.my_all? { |n| n < 4 })
puts
puts 'hash.all? { |key, value| value < 4 } output: '
p(hash.all? { |_key, value| value < 4 })
puts 'hash.my_all? { |key, value| value < 4 } output: '
p(hash.my_all? { |_key, value| value < 4 })

# any? vs. my_any?
puts '-' * 80
puts 'any? vs. my_any?'
puts '-' * 80
puts
puts 'array.any? output: ' + array.any?.to_s
puts 'array.my_any? output: ' + array.my_any?.to_s
puts
puts 'array.any? { |n| n == 4 } output:'
p(array.any? { |n| n == 4 })
puts 'array.my_any? { |n| n == 4 } output: '
p(array.my_any? { |n| n == 4 })
puts
puts 'hash.any? {|key, value| key == :z} output: '
p(hash.any? { |key, _value| key == :z })
puts 'hash.my_any? {|key, value| key == :z} output: '
p(hash.my_any? { |key, _value| key == :z })

# none? vs. my_none?
puts '-' * 80
puts 'none? vs. my_none?'
puts '-' * 80
puts
puts 'array.none? output: ' + array.none?.to_s
puts 'array.my_none? output: ' + array.my_none?.to_s
puts
puts 'array.none? { |n| n == 5 } output: '
p(array.none? { |n| n == 5 })
puts 'array.my_none? { |n| n == 5 } output: '
p(array.my_none? { |n| n == 5 })
puts
puts 'hash.none? { |key, value| key == :c } output: '
p(hash.none? { |key, _value| key == :c })
puts 'hash.none? { |key, value| key == :c} output: '
p(hash.none? { |key, _value| key == :c })
puts
puts

# count? vs. my_count?
puts '-' * 80
puts 'count? vs. my_count?'
puts '-' * 80
puts
puts 'array.count output: ' + array.count.to_s
puts 'array.count output: ' + array.my_count.to_s
puts
puts 'array.count(1) output: '
p array.count(1)
puts 'array.my_count(1) output: '
p array.my_count(1)
puts
puts 'array.count { |n| n > 1 } output: '
p(array.count { |n| n > 1 })
puts 'array.my_count { |n| n > 1 }'
p(array.my_count { |n| n > 1 })
puts
puts 'hash.count { |key, value| value.odd? } output: '
p(hash.count { |_key, value| value.odd? })
puts 'hash.my_count { |key, value| value.odd? } output: '
p(hash.my_count { |_key, value| value.odd? })

# map vs. my_map
puts '-' * 80
puts 'map vs. my_map'
puts '-' * 80
puts
puts 'array.map output: ' + array.map.to_s
puts 'array.my_map output: ' + array.my_map.to_s
puts
puts 'array.map { |n| n * 10 } output: '
p(array.map { |n| n * 10 })
puts 'array.my_map { |n| n * 10 } output: '
p(array.my_map { |n| n * 10 })
puts
puts 'hash.map { |key, value| [key, value] } output: '
p(hash.map { |key, value| [key, value] })
puts 'hash.my_map { |key, value| [key, value] } output: '
p(hash.my_map { |key, value| [key, value] })
puts

# inject vs. my_inject
puts '-' * 80
puts 'inject vs. my_inject'
puts '-' * 80
puts
puts 'array.inject(:-) output: ' + array.inject(:-).to_s
puts 'array.my_inject(:-) output: ' + array.my_inject(:-).to_s
puts
puts 'array.inject { |memo, n| memo - n } output: '
p(array.inject { |memo, n| memo - n })
puts 'array.my_inject { |memo, n| memo - n } output: '
p(array.my_inject { |memo, n| memo - n })
puts
puts 'array.inject(3, :-) output: '
p(array.inject(3, :-))
puts 'array.my_inject(3, :-) output: '
p(array.my_inject(3, :-))
puts
puts 'array.inject(2) { |memo, n| memo * n } output: '
p(array.inject(2) { |memo, n| memo * n })
puts 'array.my_inject(2) { |memo, n| memo * n } output: '
p(array.my_inject(2) { |memo, n| memo * n })
puts
puts 'inject_test = array_of_words.inject do |memo, word|
  memo.length > word.length ? memo : word
end output: '
inject_test = array_of_words.inject do |memo, word|
  memo.length > word.length ? memo : word
end
p inject_test
puts 'my_inject_test = array_of_words.my_inject do |memo, word|
  memo.length > word.length ? memo : word
end'
my_inject_test = array_of_words.my_inject do |memo, word|
  memo.length > word.length ? memo : word
end
p my_inject_test
puts

# multiply_els method created to test my_inject method
puts '-' * 80
puts 'multiply_els method'
puts '-' * 80
puts
puts 'def multiply_els(array)
  array.my_inject do |memo, n|
    memo * n
  end
end'
def multiply_els(array)
  array.my_inject do |memo, n|
    memo * n
  end
end
puts
puts 'multiply_els([2, 4, 5]) output: ' + multiply_els([2, 4, 5]).to_s
puts

# Proc to test the implementation of the my_map method
puts '-' * 80
puts 'Proc to test the implementation of my_map method'
puts '-' * 80
puts
puts 'test_proc = proc { |n| n * 7 }'
test_proc = proc { |n| n * 7 }
puts 'array.map { |n| n * 7 } output: ' + array.map { |n| n * 7 }.to_s
puts 'array.my_map(&test_proc) output: ' + array.my_map(&test_proc).to_s
puts
puts
