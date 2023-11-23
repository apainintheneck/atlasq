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
      # @param id_to_raw_names [Hash<String, Array<String>>]
      def initialize(id_to_raw_names)
        @id_to_raw_names = id_to_raw_names
      end

      # Search for ids that include all of the search term words.
      #
      # @param search_term [String]
      # @return [Array<String>] list of ids
      def search(search_term)
        search_term
          .then { |string| split(string) }
          .map { |word| Util::String.normalize(word) }
          .uniq
          .map { |word| word_map[word] }
          .inject(&:intersection)
          .sort
      end

      private

      # A map of words to ids.
      #
      # @return [Hash<String, Set<String>>]
      def word_map
        @word_map ||= begin
          word_map = Hash.new { |hash, key| hash[key] = Set.new }

          @id_to_raw_names.each do |id, raw_names|
            words = raw_names
              .flat_map { |string| split(string) }
              .map { |word| Util::String.normalize(word) }
              .uniq
            
            words.each do |word|
              word_map[word] << id
            end
          end

          word_map
        end
      end

      # Split on spaces, tabs and punctuation separators.
      # Note: Some punctuation can be connectors or separators based on the language.
      #
      # @param sentence [String]
      # @return [Array<String>]
      def split(sentence)
        sentence.split(/[ \t,;:()]+/)
      end
    end
  end
end
