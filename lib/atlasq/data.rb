# frozen_string_literal: true

require "countries"
require "delegate"
require "iso-639"
require "money"

ISO3166.configuration.enable_currency_extension!

module Atlasq
  module Data
    class Countries < DelegateClass(Array); end

    # @param term [String]
    # @return [ISO3166::Country, nil]
    def self.country(term)
      ISO3166::Country.find_country_by_alpha2(term) ||
        ISO3166::Country.find_country_by_alpha3(term) ||
        ISO3166::Country.find_country_by_number(term) ||
        ISO3166::Country.find_country_by_translated_names(term)
    end

    # @return [Atlasq::Data::Countries]
    def self.all_countries
      Countries.new(ISO3166::Country.all)
    end
  end
end
