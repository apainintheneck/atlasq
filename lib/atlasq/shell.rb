# frozen_string_literal: true

module Atlasq
  module Shell
    SKIP_PAGER = %i[usage version].freeze
    def self.start!(args = ARGV)
      warn "DEBUG: ARGV: #{ARGV}" if DEBUG
      options = Command.parse(args)
      warn "DEBUG: options: #{options}" if DEBUG
      command = Command.lookup(options.command)
      content = command.run(options)

      exit(1) if content.empty?

      if $stdout.tty? && command.to_pager?
        require "tty-pager"
        TTY::Pager.page(content)
      else
        puts content
      end
    end
  end
end
