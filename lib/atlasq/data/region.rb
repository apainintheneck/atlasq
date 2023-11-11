# frozen_string_literal: true

require "delegate"

module Atlasq
  module Data
    class Region < DelegateClass(Array)
      # TODO: Find out how to better document the types here
      attr_reader :type, :name, :countries

      # @param countries [Array<Hash>]
      # @param type [Symbol] in Atlasq::Data::REGION_TYPES
      def initialize(countries:, type:)
        @type = type.to_s
        @name = countries.dig(0, @type)
        @countries = countries

        super(countries)
      end
    end
  end
end
