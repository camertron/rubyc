# frozen_string_literal: true

require 'syntax_tree'

module RubyC
  class Visitor < SyntaxTree::Visitor
    attr_reader :doc

    def initialize(ext_name)
      @scope_stack = [TopLevelScope.new]
      @doc = Document.new
      @current_section = @doc.init_func

      doc.includes.write_c_line('#include "ruby/ruby.h"')
      doc.init_func.write_c_line("void Init_#{ext_name}() {")
      doc.init_func.indent
    end

    def finalize
      doc.init_func.dedent
      doc.init_func.write_c_line('}')
    end

    def visit_class(node)
      klass = ClassScope.new(current_scope, node)
      doc.init_func.write_c_line("VALUE #{klass.c_name} = rb_define_class(\"#{klass.name}\", rb_cObject);")
      @scope_stack.push(klass)
      visit_child_nodes(node)
      @scope_stack.pop
    end

    def visit_def(node)
      method = MethodScope.new(current_scope, node)
      @scope_stack.push(method)

      doc.init_func.write_c_line("rb_define_method(#{current_scope.parent_scope.c_name || 'rb_mKernel'}, \"#{method.name}\", #{method.c_name}, #{method.params.arity});")
      doc.signatures.write_c(method.signature)
      doc.signatures.write_c_line(';')

      doc.methods.write_c_line("#{method.signature} {")
      doc.methods.indent

      body_statements = node.bodystmt.statements.child_nodes

      if body_statements.empty?
        doc.methods.write_c_line('return Qnil;')
      else
        body_statements.each_with_index do |body_node, idx|
          if idx == body_statements.size - 1
            doc.methods.write_c('return ')
          end

          within_section(doc.methods) { visit(body_node) }
          doc.methods.write_c_line(';')
        end
      end

      doc.methods.dedent
      doc.methods.write_c_line('}')

      @scope_stack.pop
    end

    def visit_statements(node)
      node.body.each_with_index do |statement, idx|
        case statement
          when SyntaxTree::ClassDeclaration, SyntaxTree::Def, SyntaxTree::VoidStmt
            visit(statement)
          else
            if current_scope.type == :top_level
              within_section(doc.init_func) { visit(statement) }
              doc.init_func.write_c_line(';')
            end
        end
      end
    end

    def visit_call(node)
      current_section.write_c('rb_funcall(')
      visit(node.receiver)
      current_section.write_c(', rb_intern("')
      visit(node.message)
      current_section.write_c('"), ')

      if node.arguments
        visit(node.arguments)
      else
        current_section.write_c('0')
      end

      current_section.write_c(')')
    end

    def visit_command(node)
      current_section.write_c('rb_funcall(rb_mKernel, rb_intern("')
      visit(node.message)
      current_section.write_c('"), ')

      if node.arguments
        visit(node.arguments)
      else
        current_section.write_c('0')
      end

      current_section.write_c(')')
    end

    def visit_args(node)
      current_section.write_c(node.parts.size.to_s)
      current_section.write_c(', ')

      node.parts.each_with_index do |arg, idx|
        current_section.write_c(', ') if idx > 0
        visit(arg)
      end
    end

    def visit_int(node)
      current_section.write_c("LONG2NUM(#{node.value})")
    end

    def visit_ident(node)
      current_section.write_c(node.value)
    end

    def visit_binary(node)
      current_section.write_c('rb_funcall(')
      visit(node.left)
      current_section.write_c(", rb_intern(\"#{node.operator}\"), 1, ")
      visit(node.right)
      current_section.write_c(')')
    end

    def visit_var_ref(node)
      current_section.write_c(node.child_nodes[0].value)
    end

    private

    attr_reader :current_section

    def current_scope
      @scope_stack.last
    end

    def within_section(section)
      @old_section = @current_section
      @current_section = section
      yield
      @current_section = @old_section
    end
  end
end