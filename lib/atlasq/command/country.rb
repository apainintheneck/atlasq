# frozen_string_literal: true

require_relative "base"

require "countries"
require "iso-639"
require "money"

ISO3166.configuration.enable_currency_extension!

module Atlasq
  module Command
    class Country < Base
      # @return [String]
      def content
        options.args.map do |search_term|
          country = find_country(search_term)
          if country
            # TODO: Add search term to output
            format_country(country)
          else
            "Unknown country: #{search_term}"
          end
        end.join("\n\n")
      end

      # @param term [String]
      # @return [ISO3166::Country]
      def find_country(term)
        ISO3166::Country.find_country_by_alpha2(term) ||
          ISO3166::Country.find_country_by_alpha3(term) ||
          ISO3166::Country.find_country_by_number(term) ||
          ISO3166::Country.find_country_by_translated_names(term)
      end

      # @param country [ISO3166::Country]
      # @return [String]
      def format_country(country)
        <<~COUNTRY
          *
          * #{country.iso_long_name}
          * #{"* " * ((country.iso_long_name.size / 2) + 2)}
          [#{country.number} | #{country.alpha2} | #{country.alpha3} | #{country.iso_short_name}]
           | Languages: #{format_languages(country.languages)}
            | Nationality: #{country.nationality}
             | Continent: #{country.continent}
              | Region: #{country.subregion}
               | Currency: #{country.currency.symbol} #{country.currency.name}
                |___________________________________________
        COUNTRY
      end

      # @param languages [Array<String>] Ex. ["id"]
      # @return [String]
      def format_languages(languages)
        languages
          .take(4)
          .map do |lang|
            ISO_639
              .find(lang)
              .english_name
              .split(";")
              .first
          end
          .join(", ")
      end
    end
  end
end
