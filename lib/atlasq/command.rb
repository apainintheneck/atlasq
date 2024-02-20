# frozen_string_literal: true

module Atlasq
  module Command
    autoload :Any, "atlasq/command/any"
    autoload :Country, "atlasq/command/country"
    autoload :Region, "atlasq/command/region"
    autoload :Money, "atlasq/command/money"
    autoload :Version, "atlasq/command/version"
    autoload :Help, "atlasq/command/help"
    autoload :Usage, "atlasq/command/usage"

    # @param command [Atlasq::Command::Base]
    # @param args [Array<String>]
    Options = Struct.new(:command, :args, keyword_init: true)

    # @param args [Array<String>] command line arguments
    # @return [Atlasq::Command::Options]
    def self.parse(args)
      command = parse_command(args.first)
      args.shift unless command.to_s == "Atlasq::Command::Any"
      args.map!(&:strip)

      Options.new(command: command, args: args).freeze
    end

    # @param command [String]
    # @return [Atlasq::Command::Base]
    def self.parse_command(command)
      case command
      when "-c", "--country", "--countries"
        Country
      when "-r", "--region", "--regions"
        Region
      when "-m", "--money"
        Money
      when "-v", "--version"
        Version
      when "-h", "--help"
        Help
      when nil
        Usage
      else
        Any
      end
    end
  end
end
