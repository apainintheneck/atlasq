# frozen_string_literal: true

require_relative "base"

module Atlasq
  module Command
    class Money < Base
      def content
        if search_terms.empty?
          currencies = Data.all_currencies
          Format.currencies(currencies)
        else
          search_terms.map do |term|
            if (currencies = Data.countries_by_currencies(term))
              Format.currencies(currencies)
            elsif (currency_codes = PartialMatch.currencies(term)).any?
              currencies = Data.countries_by_currencies(currency_codes)
              Format.currencies(currencies, partial_match: true)
            else
              Atlasq.failed!
              "Unknown currency: #{term}"
            end
          end.join("\n\n")
        end
      end
    end
  end
end
