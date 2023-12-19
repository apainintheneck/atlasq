# frozen_string_literal: true

require_relative "base"

module Atlasq
  module Command
    class Country < Base
      # @return [String]
      def content
        if search_terms.empty?
          country_codes = Data.all_countries
          Format.countries(country_codes, title: "All Countries")
        else
          search_terms.map do |term|
            if (country_code = Data.country(term))
              Format.country(country_code)
            elsif (country_codes = PartialMatch.countries(term)).any?
              Format.countries(country_codes, title: "Countries (Partial Match)")
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
