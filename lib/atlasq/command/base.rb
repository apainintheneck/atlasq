# frozen_string_literal: true

module Atlasq
  module Command
    class Base
      # @param options [Atlasq::Command::Options]
      # @return [String]
      def self.run(options)
        new(options).content
      end

      # @return [Boolean]
      def self.to_pager?
        true
      end

      # @param options [Atlasq::Command::Options]
      def initialize(options)
        @options = options
      end

      # @return [String]
      def content
        NotImplementedError
      end
    end
  end
end
