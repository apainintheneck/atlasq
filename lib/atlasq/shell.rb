# frozen_string_literal: true

module Atlasq
  module Shell
    SKIP_PAGER = %i[usage version].freeze

    def self.start!(args = ARGV)
      warn "DEBUG: args: #{args}" if DEBUG
      options = Command.parse(args)
      warn "DEBUG: options: #{options}" if DEBUG
      content = options.command.run(options.args)

      if content.empty?
        Atlasq.failed!
      elsif use_pager?(options, content)
        require "tty-pager"
        TTY::Pager.page(content)
      else
        puts content
      end

      exit(1) if Atlasq.failed?
    end

    DEFAULT_SHELL_HEIGHT = 24

    def self.use_pager?(options, content)
      $stdout.tty? &&
        options.command.to_pager? &&
        content.count("\n") >= DEFAULT_SHELL_HEIGHT
    end
  end
end
