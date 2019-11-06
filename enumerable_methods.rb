#!/usr/bin/env ruby
# frozen_string_literal: true

# This module contains an implementation on the methods found in the
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

end

puts [1, 2, 3].each
puts [1, 2, 3].my_each

[1, 2, 3].each { |n| p n }
[1, 2, 3].my_each { |n| p n }

hash = {a: 1, b: 2, c: 3}
hash.each { |key, value| puts "Key: #{key}, Value: #{value}" }
hash.my_each { |key, value| puts "Key: #{key}, Value: #{value}" }
