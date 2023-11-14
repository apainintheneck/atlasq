# frozen_string_literal: true

require "countries"
require "iso-639"
require "money"
require "money-heuristics"

ISO3166.configure do |config|
  # Needed to allow us to access the `ISO3166::Country#currency`
  # object which ends up being an instance of `Money::Currency`.
  config.enable_currency_extension!

  # Needed to allow us to search by localized country name.
  config.locales = %i[
    af am ar as az be bg bn br bs
    ca cs cy da de dz el en eo es
    et eu fa fi fo fr ga gl gu he
    hi hr hu hy ia id is it ja ka
    kk km kn ko ku lt lv mi mk ml
    mn mr ms mt nb ne nl nn oc or
    pa pl ps pt ro ru rw si sk sl
    so sq sr sv sw ta te th ti tk
    tl tr tt ug uk ve vi wa wo xh
    zh zu
  ]
end

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
        ISO3166::Country.find_country_by_number(term) ||
        ISO3166::Country.find_country_by_any_name(term)
    end

    # @return [Array<ISO3166::Country>]
    def self.all_countries
      @all_countries ||= ISO3166::Country.all
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

    # @param number [String] ISO3166-1 numeric country code
    # @return [String|nil]
    def self.emoji_flag(iso_number)
      @emoji_flag ||= all_countries
        .to_h { |country| [country.number, country.emoji_flag] }
        .freeze

      @emoji_flag[iso_number]
    end
  end
end
