# frozen_string_literal: true

module Atlasq
  module Command
    LOOKUP = {
      any: Command::Any,
      country: Command::Country,
      region: Command::Region,
      money: Command::Money,
      timezone: Command::Money,
      help: Command::Help,
      usage: Command::Usage
    }.freeze
    private_constant :LOOKUP

    def self.lookup(command)
      raise Error, "Unknown command: #{command}" unless LOOKUP.key?(command)

      LOOKUP.fetch(command)
    end

    Options = Struct.new(:command, :args, :debug, :verbose, keyword_init: true)

    def self.parse(args)
      debug = true if args.delete("-d")
      debug = true if args.delete("--debug")

      verbose = true if args.delete("-v")
      verbose = true if args.delete("--verbose")

      command = parse_command(args.first)
      args.shift unless %i[usage any].include?(command)

      Options.new(
        command: command,
        args: args,
        debug: debug,
        verbose: verbose
      ).freeze
    end

    def self.parse_command(command)
      case command
      when "-c", "--country", "--countries"
        :country
      when "-r", "--region", "--regions"
        :region
      when "-m", "--money"
        :money
      when "-t", "-z", "--tz", "--timezone", "--timezones"
        :timezone
      when "-h", "--help"
        :help
      when nil
        :usage
      else
        :any
      end
    end
  end
end
