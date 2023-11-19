# frozen_string_literal: true

module Atlasq
  module Data
    class Region
      # @return [Symbol]
      attr_reader :type

      # @return [String, nil]
      attr_reader :name

      # @return [Array<Hash>]
      attr_reader :countries

      # @param countries [Array<Hash>]
      # @param type [Symbol] in Atlasq::Data::REGION_TYPES
      def initialize(countries:, type:)
        @type = type
        @name = countries.dig(0, @type.to_s)
        @countries = countries
      end
    end
  end
end
