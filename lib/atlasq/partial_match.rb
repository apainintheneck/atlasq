# frozen_string_literal: true

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
    # @return [Array<String>] 2 letter language codes (ISO639)
    def self.languages(term)
      @languages ||= Util::WordMap.new(index: Cache.get("search_index/partial_match_language.json"))
      @languages.search(term)
    end
  end
end
