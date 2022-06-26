$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'rubyc/version'

Gem::Specification.new do |s|
  s.name     = 'rubyc'
  s.version  = ::RubyC::VERSION
  s.authors  = ['Cameron Dutro']
  s.email    = ['camertron@gmail.com']
  s.homepage = 'http://github.com/camertron/ruby'
  s.description = s.summary = 'Compile your Ruby code.'
  s.platform = Gem::Platform::RUBY

  s.add_dependency 'syntax_tree'

  s.require_paths = ['lib', 'ext']

  s.executables << 'rubyc'

  s.files = Dir['{lib,spec}/**/*', 'Gemfile', 'LICENSE', 'CHANGELOG.md', 'README.md', 'Rakefile', 'rubyc.gemspec']
end
