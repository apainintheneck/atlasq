# frozen_string_literal: true

module Atlasq
  module Data
    # @param term [String] search term
    # @return [String, nil] ISO3166 2 letter country code
    def self.country(term)
      Cache
        .get("search_index/direct_match_country.json")
        .dig(term)
    end

    # @param term [String] search term
    # @return [Array<String>, nil] ISO3166 2 letter country codes
    def self.countries_by_region(term)
      Cache
        .get("search_index/countries_by_region.json")
        .dig(term)
    end

    # @return [Array<String>] ISO3166 2 letter country codes
    def self.all_countries
      Cache.get("list/all_countries.json")
    end

    # @return [Array<String>]
    def self.all_subregions
      subregions = Cache.get("list/all_subregions.json")

      Cache
        .get("search_index/countries_by_region.json")
        .slice(*subregions)
    end

    # @param terms [String, Array<String>] search terms
    # @return [Hash<String, Array<String>>] ISO4127 3 letter currency code to ISO3166 2 letter country codes
    def self.countries_by_currencies(terms)
      terms = Array(terms)
      currency_codes = Cache
        .get("search_index/direct_match_currency.json")
        .values_at(*terms)
        .compact

      return if currency_codes.empty?

      Cache
        .get("search_index/countries_by_currency.json")
        .slice(*currency_codes)
    end

    # @return [Hash<String, Array<String>>] ISO4127 3 letter currency code to ISO3166 2 letter country codes
    def self.all_currencies
      Cache.get("search_index/countries_by_currency.json")
    end
  end
end
