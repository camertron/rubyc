# frozen_string_literal: true

require 'benchmark/ips'
require 'rubyc'

class FooRuby
  def foo(arg)
    BarRuby.new.bar do
      arg
    end
  end
end

class BarRuby
  def bar(&block)
    block.call
  end
end

def do_it_ruby
  FooRuby.new.foo("arg")
end

Benchmark.ips do |x|
  x.report("ruby") { do_it_ruby }
  x.report("c") { do_it }
  x.compare!
end
