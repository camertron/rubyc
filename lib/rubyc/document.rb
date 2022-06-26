# frozen_string_literal: true

module RubyC
  class Document
    attr_reader :includes, :signatures, :methods, :init_func

    def initialize
      @includes = Section.new
      @signatures = Section.new
      @methods = Section.new
      @init_func = Section.new
    end

    def to_s
      [includes, signatures, methods, init_func].map(&:to_s).join("\n")
    end
  end
end
