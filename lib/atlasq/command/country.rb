# frozen_string_literal: true

require_relative "base"

module Atlasq
  module Command
    class Country < Base
      # @return [String]
      def content
        search_terms.map do |search_term|
          country = Data.country(search_term)
          if country
            Format.country(country, search_term)
          else
            Atlasq.failed!
            "Unknown country: #{search_term}"
          end
        end.join("\n\n")
      end
    end
  end
end
