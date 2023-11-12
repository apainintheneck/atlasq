# frozen_string_literal: true

require "delegate"

module Atlasq
  module Data
    class Currency < DelegateClass(Array)
      # @return [String]
      attr_reader :currency_code

      # @return [Array<Hash>]
      attr_reader :countries

      # @param countries [Array<Hash>]
      # @param currency_code [String] ISO 4217 currency code
      def initialize(countries:, currency_code:)
        @countries = countries
        @currency_code = currency_code

        super(countries)
      end
    end
  end
end
