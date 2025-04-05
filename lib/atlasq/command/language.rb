# frozen_string_literal: true

require_relative "base"

module Atlasq
  module Command
    class Language < Base
      # @return [String]
      def content
        if search_terms.empty?
          languages = Data.all_languages
          Format.languages(languages)
        else
          search_terms.map do |term|
            if (countries_by_languages = Data.countries_by_languages(term))
              Format.languages(countries_by_languages)
            elsif (language_codes = PartialMatch.languages(term)).any?
              countries_by_languages = Data.countries_by_languages(language_codes)
              Format.languages(countries_by_languages, partial_match: true)
            else
              Atlasq.failed!
              "Unknown language: #{term}"
            end
          end.join("\n\n")
        end
      end
    end
  end
end
