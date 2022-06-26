# frozen_string_literal: true

module RubyC
  class TopLevelScope < Scope
    def type
      :top_level
    end

    def c_name
      'rb_mKernel'
    end
  end
end
