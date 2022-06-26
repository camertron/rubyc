# frozen_string_literal: true

module RubyC
  class Scope
    def method_scopes
      @method_scopes ||= []
    end

    def class_scopes
      @class_scopes ||= []
    end

    def module_scopes
      @module_scopes ||= []
    end

    def statements
      @statements ||= []
    end

    def add_method(method_scope)
      method_scopes << method_scope
    end

    def add_class(class_scope)
      class_scopes << class_scope
    end

    def add_module(module_scope)
      module_scopes << module_scope
    end

    def add_statement(statement)
      statements << statement
    end

    def c_name
      nil
    end
  end
end
