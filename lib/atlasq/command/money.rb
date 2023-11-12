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
            currencies = Data.currencies(term)

            if currencies.empty?
              Atlasq.failed!
              "Unknown currency: #{term}"
            else
              Format.currencies(currencies)
            end
          end.join("\n\n")
        end
      end
    end
  end
end
