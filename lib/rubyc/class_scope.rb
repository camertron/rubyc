# frozen_string_literal: true

module RubyC
  class ClassScope < Scope
    attr_reader :parent_scope, :node

    def initialize(parent_scope, node)
      @parent_scope = parent_scope
      @node = node
    end

    def type
      :class
    end

    def c_name
      @c_name ||= [parent_scope.c_name, name].compact.join('_')
    end

    def name
      # @TODO: this will need to be much smarter
      @name ||= node.constant.constant.value
    end
  end
end
