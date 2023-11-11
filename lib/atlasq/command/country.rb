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
            country = Data.country(term)

            if country
              Format.country(country, term)
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
