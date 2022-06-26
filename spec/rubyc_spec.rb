# frozen_string_literal: true

require 'spec_helper'

describe 'RubyC' do
  it 'compiles a simple function that adds two numbers' do
    load_fixture! 'add'

    expect(add(1, 2)).to eq(3)
  end

  it 'compiles a basic class with an instance method' do
    load_fixture! 'adder'

    expect(Adder.new.add(1, 2)).to eq(3)
  end
end
