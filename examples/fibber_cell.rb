#!/usr/bin/env ruby
require 'celluloid/cellulate'

##
# This example demonstrates conditional extension
# and replacement of an object with its celluloid
# proxy, as well as conditional handling of future
# calls which can be used to block until complete
# or extract ready values and move on
##

class Mathematician
  # A base class which can be extended
  # if we include ::Celluloid here, our extension
  # will fail and the celluloid object wont get
  # the fib method from our module.
end

module Fibber
  # Additional functionality given to our math wiz
  def fib(n)
    n < 2 ? n : fib(n-1) + fib(n-2)
  end
end

# A base class extended with a module
fibonacci = Mathematician.new
fibonacci.extend(Fibber)

# Conditional extension and replacement
if Time.now.to_i % 2 == 0
  fibonacci.extend(Celluloid::Cellulate)
  # Dangerous substitution
  fibonacci = fibonacci.send(:cellulate)
  puts "Fasionably late, but ready to work"
end

results = []
# Some work to do
1.upto(rand(40)+10) do |int|
  if fibonacci.respond_to?(:future)
    results << fibonacci.future(:fib,int)
  else
    results << fibonacci.fib(int)
  end
end

# Wait for results or move along if applicable
if fibonacci.respond_to?(:future)
  if Time.now.to_i % 2 == 1
    # Block until we get our responses
    results = results.map(&:value)
  else
    # Take the results we have up til now and move on
    results = results.keep_if(&:ready?).map(&:value)
    fibonacci.terminate
  end
end

# Lets see what we have
puts results.join(", ")
