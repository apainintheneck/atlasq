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
            if (languages = Data.countries_by_languages(term))
              Format.languages(languages)
            elsif (currency_codes = PartialMatch.languages(term)).any?
              languages = Data.countries_by_languages(currency_codes)
              Format.languages(languages, partial_match: true)
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
