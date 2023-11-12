# frozen_string_literal: true

require_relative "base"

module Atlasq
  module Command
    class Usage < Base
      # @return [Boolean]
      def self.to_pager?
        false
      end

      # @return [String]
      def content
        <<~USAGE
          atlasq is a utility to query country info

          usage:
            atlasq query...
            atlasq [command] query...
            atlasq -i/--interactive
            atlasq -h/--help
            atlasq -v/--version

          commands:
            -c/--country  : find countries
            -r/--region   : find countries by region
            -m/--money    : find countries by currency
        USAGE
      end
    end
  end
end
