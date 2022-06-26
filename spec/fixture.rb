# frozen_string_literal: true

require 'fileutils'

module RubyC
  class Fixture
    attr_reader :source_file

    def initialize(source_file)
      @source_file = source_file
      @built = false
      @required = false
    end

    def build!
      return if @built

      FileUtils.mkdir_p(ext_dir)

      Dir.chdir(ext_dir) do
        File.write('extconf.rb', <<~RUBY)
          require 'mkmf'

          $CFLAGS << ' -Wno-compound-token-split-by-macro'
          $CFLAGS << ' -O3'

          create_makefile '#{ext_name}'
        RUBY

        File.write(
          "#{ext_name}.c",
          RubyC.transpile(source_file, ext_name)
        )

        system 'ruby extconf.rb'
        system 'make'
      end

      @built = true
    end

    def require!
      return if @required

      require File.join(ext_dir, ext_name)
      @required = true
    end

    private

    def source_dir
      @source_dir ||= File.dirname(source_file)
    end

    def source_basename
      @source_basename ||= File.basename(source_file)
    end

    def ext_dir
      @ext_dir ||= File.join(source_dir, ext_name)
    end

    def ext_name
      @ext_name ||= source_basename.chomp(File.extname(source_basename))
    end
  end
end
