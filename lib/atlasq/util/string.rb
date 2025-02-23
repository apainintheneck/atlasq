# frozen_string_literal: true

require "unaccent"

module Atlasq
  module Util
    module String
      ABBREVIATIONS = {
        "AMER" => "North, Central and South America",
        "APAC" => "Asia-Pacific",
        "EMEA" => "Europe, Middle East, and Africa"
      }.freeze

      # @param string [String]
      # @return [String]
      def self.titleize(string)
        abbreviation = string.upcase

        if (full_name = ABBREVIATIONS[abbreviation])
          "#{full_name} (#{abbreviation})"
        else
          words = string.split(/[-_ \t]+/)
          words.map! do |word|
            if word.match?(/^(?:of|the|and)$/i)
              word.downcase
            else
              word.capitalize
            end
          end
          words.join(" ")
        end
      end

      # Make string lowercase and remove accents.
      #
      # @param string [String]
      # @return [String]
      def self.normalize(string)
        @normalize ||= {}
        @normalize[string] ||= Unaccent.unaccent(string.downcase)
      end

      # Split on spaces, tabs and punctuation separators.
      # Note: Some punctuation can be connectors or separators based on the language.
      #
      # @param sentence [String]
      # @return [Array<String>]
      def self.word_split(sentence)
        sentence.split(/[ \t,;:()]+/).reject(&:empty?)
      end
    end
  end
end
