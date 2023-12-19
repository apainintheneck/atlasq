# frozen_string_literal: true

require "iso-639"

module Atlasq
  module PartialMatch
    # @param term [String]
    # @return [Array<String>] 3 digit country codes (ISO3166)
    def self.countries(term)
      @countries ||= Util::WordMap.new(index: Cache.get("search_index/partial_match_country.json"))
      @countries.search(term)
    end

    # @param term [String]
    # @return [Array<String>] 3 letter currency codes (ISO4217)
    def self.currencies(term)
      @currencies ||= Util::WordMap.new(index: Cache.get("search_index/partial_match_currency.json"))
      @currencies.search(term)
    end

    # @param term [String]
    # @return [Array<String>] 3 letter language codes (ISO639)
    def self.languages(term)
      @languages ||= begin
        language_data = (ISO_639::ISO_639_1 | ISO_639::ISO_639_2)
        id_to_language_names = language_data
          .to_h { |language| [language.alpha3, [language.english_name, language.french_name]] }

        Util::WordMap.new(id_to_language_names)
      end

      @languages.search(term)
    end
  end
end
