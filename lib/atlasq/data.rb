# frozen_string_literal: true

require "countries"
require "iso-639"
require "money"
require "money-heuristics"

ISO3166.configuration.enable_currency_extension!

module Atlasq
  module Data
    autoload :Currency, "atlasq/data/currency"
    autoload :Region, "atlasq/data/region"

    # @param term [String]
    # @return [ISO3166::Country|Atlasq::Data::Region|Atlasq::Data::Currency|nil]
    def self.any(term)
      Data.country(term) ||
        Data.region(term) ||
        Data.currencies(term)
    end

    # @param term [String]
    # @return [ISO3166::Country|nil]
    def self.country(term)
      ISO3166::Country.find_country_by_alpha2(term) ||
        ISO3166::Country.find_country_by_alpha3(term) ||
        ISO3166::Country.find_country_by_gec(term) ||
        ISO3166::Country.find_country_by_number(term) ||
        ISO3166::Country.find_country_by_any_name(term)
    end

    # @return [Array<ISO3166::Country>]
    def self.all_countries
      ISO3166::Country.all
    end

    # Region types for querying ISO3166::Country
    REGION_TYPES = %i[region subregion world_region continent].freeze

    # @return [Atlasq::Data::Region|nil]
    def self.region(term)
      REGION_TYPES.each do |region_type|
        countries = ISO3166::Country.find_all_by(region_type, term)
        next if countries.empty?

        return Region.new(countries: countries.values, type: region_type)
      end
      nil
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

    # @param term [String]
    # @return [Array<Atlasq::Data::Currency>]
    def self.currencies(term)
      currency_codes = Money::Currency.analyze(term)
      currency_codes = [term] if currency_codes.empty?
      currency_codes.filter_map do |currency_code|
        countries = ISO3166::Country.find_all_by(:currency_code, currency_code)
        next if countries.empty?

        Currency.new(countries: countries.values, currency_code: currency_code)
      end
    end

    # @return [Array<Atlasq::Data::Currency>]
    def self.all_currencies
      all_countries
        .group_by(&:currency_code)
        .map do |currency_code, countries|
          Currency.new(countries: countries, currency_code: currency_code)
        end
    end
  end
end
