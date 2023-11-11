# frozen_string_literal: true

require_relative "base"

module Atlasq
  module Command
    class Any < Base
      def content
        search_terms.map do |term|
          data = Data.any(term)

          if data
            Format.any(data, term)
          else
            Atlasq.failed!
            "Unknown search term: #{term}"
          end
        end.join("\n\n")
      end
    end
  end
end
