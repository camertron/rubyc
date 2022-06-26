# frozen_string_literal: true

$:.push(__dir__)

require 'rspec'
require 'rubyc'
require 'fixture'
require 'pry-byebug'

module RubyC
  module RSpecHelpers
    def load_fixture!(name)
      fixtures[name] ||= RubyC::Fixture.new(
        File.expand_path(File.join('fixtures', "#{name}.rb"), __dir__)
      )

      fixtures[name].build!
      fixtures[name].require!
    end

    def fixtures
      @fixtures ||= {}
    end
  end
end

RSpec.configure do |config|
  include RubyC::RSpecHelpers
end
