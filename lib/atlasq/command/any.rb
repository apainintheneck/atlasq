# frozen_string_literal: true

require_relative "base"

module Atlasq
  module Command
    class Any < Base
      def content
        search_terms.map do |term|
          if (country = Data.country(term))
            Format.country(country, term)
          elsif (countries = Data.countries_by_region(term)).any?
            region_name = Util::String.titleize(term)
            Format.countries(countries, title: "Region: #{region_name}")
          elsif (currencies = Data.currencies(term)).any?
            Format.currencies(currencies)
          else
            Atlasq.failed!
            "Unknown search term: #{term}"
          end
        end.join("\n\n")
      end
    end
  end
end
