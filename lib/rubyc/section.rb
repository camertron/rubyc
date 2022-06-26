# frozen_string_literal: true

module RubyC
  class Section
    INDENT = '  '.freeze

    attr_reader :indent_level, :indent_str
    attr_reader :output, :started_line

    def initialize(indent_level: 0)
      @indent_level = indent_level
      @indent_str = ''
      @output = +''
      @started_line = false
    end

    def indent
      @indent_level += 1
      @indent_str += INDENT
    end

    def dedent
      @indent_level -= 1
      @indent_str = indent_str[0...(indent_str.length - INDENT.length)]
    end

    def write_c(c)
      if !started_line
        @output << indent_str
        @started_line = true
      end

      @output << indent_newlines(c)
    end

    def write_c_line(c = nil)
      if c
        @output << indent_str if !started_line
        @output << indent_newlines(c)
      end

      @output << "\n"
      @started_line = false
    end

    def ensure_newline
      if started_line
        @output << "\n"
        @started_line = false
      end
    end

    def to_s
      output
    end

    private

    def indent_newlines(str)
      str
        .gsub(/\r?\n/, "\n#{indent_str}")
        .gsub(/\n[\s]*\n/, "\n\n")
        .sub(/\n +\z/, "\n")
    end
  end
end
