# frozen_string_literal: true

module Atlasq
  module Command
    autoload :Any, "atlasq/command/any"
    autoload :Country, "atlasq/command/country"
    autoload :Region, "atlasq/command/region"
    autoload :Money, "atlasq/command/money"
    autoload :Timezone, "atlasq/command/mimezone"
    autoload :Interactive, "atlasq/command/interactive"
    autoload :Version, "atlasq/command/version"
    autoload :Help, "atlasq/command/help"
    autoload :Usage, "atlasq/command/usage"

    def self.lookup(command)
      case command
      when :any then Any
      when :country then Country
      when :region then Region
      when :money then Money
      when :timezone then TimeZone
      when :interactive then Interactive
      when :version then Version
      when :help then Help
      when :usage then Usage
      else raise Error, "Unknown command: #{command}"
      end
    end

    Options = Struct.new(:command, :args, keyword_init: true)

    def self.parse(args)
      command = parse_command(args.first)
      args.shift unless %i[usage any].include?(command)

      Options.new(command: command, args: args).freeze
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
      when "-i", "--interactive"
        :interactive
      when "-v", "--version"
        :version
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
