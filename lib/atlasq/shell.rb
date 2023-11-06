# frozen_string_literal: true

module Atlasq
  module Shell
    def self.start!(args = ARGV)
      options = Command.parse(args)
      content = Command.lookup(options.command).run(options)

      exit(1) if content.empty?

      if $stdout.tty? && options.command != :usage
        require "tty-pager"
        TTY::Pager.page(content)
      else
        puts content
      end
    end
  end
end
