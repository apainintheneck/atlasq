# frozen_string_literal: true

require_relative "base"

module Atlasq
  module Command
    class Usage < Base
      def content
        <<~USAGE
          atlasq is a utility to query country info

          usage:
            atlasq query...
            atlasq [command] query...
            atlasq -h/--help
            atlasq -v/--version

          commands:
            -c/--country  : find a country
            -r/--region   : find a region
            -m/--money    : currency <> country
            -t/--timezone : timezone <> country
        USAGE
      end
    end
  end
end
