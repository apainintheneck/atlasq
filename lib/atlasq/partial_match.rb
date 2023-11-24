# frozen_string_literal: true

module Atlasq
  module PartialMatch
    # @param term [String]
    # @return [Array<String>] 3 digit country codes (ISO3166)
    def self.countries(term)
      @countries ||= begin
        id_to_country_names = Data
          .all_countries
          .to_h do |country|
            [
              country.number,
              [
                country.iso_short_name,
                country.iso_long_name,
                *country.unofficial_names,
                *country.translated_names
              ]
            ]
          end

        Util::WordMap.new(id_to_country_names)
      end

      @countries.search(term)
    end

    # @param term [String]
    # @return [Array<String>] 3 letter currency codes (ISO4217)
    def self.currencies(term)
      @currencies ||= begin
        id_to_currency_names = Data
          .all_countries
          .to_h { |country| [country.currency.iso_code, [country.currency.name]] }

        Util::WordMap.new(id_to_currency_names)
      end

      @currencies.search(term)
    end
  end
end
