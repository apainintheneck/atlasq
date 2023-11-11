# frozen_string_literal: true

require "countries"
require "iso-639"
require "money"

ISO3166.configuration.enable_currency_extension!

module Atlasq
  module Data
    autoload :Region, "atlasq/data/region"

    # @param term [String]
    # @return nilable
    def self.any(term)
      Data.country(term) ||
        Data.region(term)
    end

    # @param term [String]
    # @return [ISO3166::Country, nil]
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

    # @return [Atlasq::Data::Region]
    def self.region(term)
      REGION_TYPES.each do |region_type|
        countries = ISO3166::Country.find_all_by(region_type, term)
        next if countries.empty?

        return Region.new(
          countries: countries.values,
          type: region_type
        )
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
  end
end
