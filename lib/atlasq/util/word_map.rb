# frozen_string_literal: true

require "set"
require "unaccent"

module Atlasq
  module Util
    # This data structure provides partial match support for words in sentences.
    #
    # For example, if we take a country like "Bonaire, Sint Eustatius and Saba"
    # the searches "Bonaire", "Sint Eustatius" and "saba bonaire" should all match
    # while the searches "bonaire france" and "saba bolivia" should not because
    # they include words not found in the original sentence.
    class WordMap
      # @param index [Hash<String, Array<String>>]
      def initialize(index:)
        @index = index
      end

      # Search for ids that include all of the search term words.
      #
      # @param search_term [String]
      # @return [Array<String>] list of ids
      def search(search_term)
        search_term
          .then(&Util::String.method(:word_split))
          .uniq
          .map { |word| @index.fetch(word, []) }
          .inject(&:intersection)
          .sort
      end
    end
  end
end
