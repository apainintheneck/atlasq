# frozen_string_literal: true

require_relative "base"

module Atlasq
  module Command
    class Country < Base
      # @return [String]
      def content
        if search_terms.empty?
          countries = Data.all_countries
          Format.countries(countries, "All Countries")
        else
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
end
