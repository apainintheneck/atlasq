# frozen_string_literal: true

require "delegate"

module Atlasq
  module Data
    class Region < DelegateClass(Array)
      # @return [Symbol]
      attr_reader :type

      # @return [String|nil]
      attr_reader :name

      # @return [Array<Hash>]
      attr_reader :countries

      # @param countries [Array<Hash>]
      # @param type [Symbol] in Atlasq::Data::REGION_TYPES
      def initialize(countries:, type:)
        @type = type
        @name = countries.dig(0, @type.to_s)
        @countries = countries

        super(countries)
      end
    end
  end
end
