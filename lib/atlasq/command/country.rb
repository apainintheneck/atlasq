# frozen_string_literal: true

require_relative "base"

module Atlasq
  module Command
    class Country < Base
      # @return [String]
      def content
        if search_terms.empty?
          countries = Data.all_countries
          Format.countries(countries, title: "All Countries")
        else
          search_terms.map do |term|
            if (country = Data.country(term))
              Format.country(country, term)
            elsif (country_codes = PartialMatch.countries(term)).any?
              countries = country_codes.map do |code|
                Data.country_by_code(code)
              end
              Format.countries(countries, title: "Countries (Partial Match)")
            else
              Atlasq.failed!
              "Unknown country: #{term}"
            end
          end.join("\n\n")
        end
      end
    end
  end
end
