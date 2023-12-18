# frozen_string_literal: true

module Atlasq
  module Command
    class Base
      attr_reader :search_terms

      # @param term [Array<String>]
      # @return [String]
      def self.run(terms)
        new(terms).content
      end

      # @return [Boolean]
      def self.to_pager?
        true
      end

      # @param search_terms [Array<String>]
      def initialize(search_terms)
        @search_terms = search_terms.map(&Util::String.method(:normalize))
      end

      # @return [String]
      def content
        NotImplementedError
      end
    end
  end
end
