require 'bundler'
require 'rspec/core/rake_task'
require 'rubygems/package_task'

Bundler::GemHelper.install_tasks

task :compile do
  puts 'Compiling extension'

  Dir.chdir('ext/rubyc_tester') do
    system('make clean')
    system('ruby extconf.rb')
    system('make')
  end

  puts 'Done'
end
