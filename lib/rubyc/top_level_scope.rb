# frozen_string_literal: true

module RubyC
  class TopLevelScope < Scope
    def type
      :top_level
    end
  end
end
