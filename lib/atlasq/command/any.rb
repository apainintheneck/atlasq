# frozen_string_literal: true

require_relative "base"

module Atlasq
  module Command
    class Any < Base
      def content
        search_terms.map do |term|
          if (country = Data.country(term))
            Format.country(country)
          elsif (country_codes = Data.countries_by_region(term))
            region_name = Util::String.titleize(term)
            Format.countries(country_codes, title: "Region: #{region_name}")
          elsif (currencies = Data.countries_by_currencies(term))
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
