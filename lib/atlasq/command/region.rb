# frozen_string_literal: true

require_relative "base"

module Atlasq
  module Command
    class Region < Base
      def content
        search_terms.map do |term|
          region = Data.region(term)

          if region
            Format.region(region)
          else
            Atlasq.failed!
            "Unknown region: #{term}"
          end
        end.join("\n\n")
      end
    end
  end
end
