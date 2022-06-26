# frozen_string_literal: true

module RubyC
  class MethodScope < Scope
    attr_reader :parent_scope, :node

    def initialize(parent_scope, node)
      @parent_scope = parent_scope
      @node = node
    end

    def signature
      "VALUE #{c_name}(#{params.to_c_params})"
    end

    def c_name
      @c_name ||= [parent_scope.c_name, name].compact.join('_')
    end

    def name
      @node.name.value
    end

    def params
      @params ||= Params.new(self, node.params.contents)
    end
  end
end