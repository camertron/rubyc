# frozen_string_literal: true

module RubyC
  class Params
    attr_reader :parent_scope, :node

    def initialize(parent_scope, node)
      @parent_scope = parent_scope
      @node = node
    end

    def to_c_params
      return "VALUE self" unless node
      ["VALUE self", *node.requireds.map { |req| "VALUE #{req.value}" }].join(", ")
    end

    def arity
      node.requireds.size
    end
  end
end
