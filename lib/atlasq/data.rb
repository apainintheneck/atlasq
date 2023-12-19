# frozen_string_literal: true

require "countries"
require "iso-639"
require "money"

# Needed to allow us to access the `ISO3166::Country#currency`
# object which ends up being an instance of `Money::Currency`.
ISO3166.configure(&:enable_currency_extension!)

module Atlasq
  module Data
    autoload :Currency, "atlasq/data/currency"

    # @param term [String]
    # @return [ISO3166::Country, nil]
    def self.country(term)
      Cache
        .get("search_index/direct_match_country.json")
        .dig(Util::String.normalize(term))
        &.then { |key| ISO3166::Country.new(key) }
    end

    # @param code [String] alpha2 country code
    # @return [ISO3166::Country, nil]
    def self.country_by_code(code)
      ISO3166::Country.find_country_by_alpha2(code)
    end

    # @return [Array<ISO3166::Country>]
    def self.all_countries
      @all_countries ||= ISO3166::Country.all
    end

    # @param term [String]
    # @return [Array<ISO3166::Country>, nil]
    def self.countries_by_region(term)
      Cache
        .get("search_index/countries_by_region.json")
        .dig(Util::String.normalize(term))
        &.map { |key| ISO3166::Country.new(key) }
    end

    # @return [Hash<String, Array<ISO3166::Country>>] Ex. { "Central Asia" => [...], ... }
    def self.all_subregions
      all_countries
        .group_by(&:subregion)
        .tap do |subregions|
          # Multiple countries do not have a valid subregion so shouldn't be shown.
          # (010 | AQ | ATA | Antarctica)
          # (074 | BV | BVT | Bouvet Island)
          # (334 | HM | HMD | Heard Island and McDonald Islands)
          subregions.delete("")
        end
    end

    # @param terms [String, Array<String>]
    # @return [Hash<Money::Currency, Array<ISO3166::Country>>]
    def self.countries_by_currencies(terms)
      terms = Array(terms).map(&Util::String.method(:normalize))
      currency_codes = Cache
        .get("search_index/direct_match_currency.json")
        .values_at(*terms)
        .compact

      return if currency_codes.empty?

      Cache
        .get("search_index/countries_by_currency.json")
        .slice(*currency_codes)
        .to_h do |currency_code, country_codes|
          [
            Money::Currency.new(currency_code),
            country_codes.map(&Data.method(:country_by_code)),
          ]
        end
    end

    # @return [Hash<Money::Currency, Array<ISO3166::Country>>]
    def self.all_currencies
      Cache
        .get("search_index/countries_by_currency.json")
        .to_h do |currency_code, country_codes|
          [
            Money::Currency.new(currency_code),
            country_codes.map(&Data.method(:country_by_code)),
          ]
        end
    end

    # @param language_code [String] ISO639 language code
    # @return [ISO_639]
    def self.language_by_code(language_code)
      @language ||= {}
      @language[language_code] ||= ISO_639.find(language_code)
    end

    # @param term [String]
    # @return [Array<ISO3166::Country>]
    def self.languages(term)
      language = language_by_code(term)
      return [] if language.nil?

      language_code = language.alpha2
      return [] if language_code.empty?

      all_languages.fetch(language_code, [])
    end

    # @return [Hash<String, ISO3166::Country>] ISO639 language code to country
    def self.all_languages
      @all_languages ||= all_countries
        .each_with_object({}) do |country, hash|
          country.languages.each do |language_code|
            hash[language_code] ||= []
            hash[language_code] << country
          end
        end
        .freeze
    end

    # @param number [String] ISO3166-1 numeric country code
    # @return [String, nil]
    def self.emoji_flag(iso_number)
      @emoji_flag ||= all_countries
        .to_h { |country| [country.number, country.emoji_flag] }
        .freeze

      @emoji_flag[iso_number]
    end
  end
end
