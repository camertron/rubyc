# frozen_string_literal: true

require 'syntax_tree'

module RubyC
  autoload :ClassScope,    'rubyc/class_scope'
  autoload :Document,      'rubyc/document'
  autoload :MethodScope,   'rubyc/method_scope'
  autoload :Params,        'rubyc/params'
  autoload :Scope,         'rubyc/scope'
  autoload :Section,       'rubyc/section'
  autoload :TopLevelScope, 'rubyc/top_level_scope'
  autoload :Visitor,       'rubyc/visitor'

  def self.transpile(file, ext_name)
    visitor = RubyC::Visitor.new(ext_name)
    tree = SyntaxTree.parse(SyntaxTree.read(file))
    visitor.visit(tree)
    visitor.finalize
    visitor.doc.to_s
  end
end
