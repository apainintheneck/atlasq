# frozen_string_literal: true

module Atlasq
  module Command
    class Base
      attr_reader :options

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

      # @param message [#to_s]
      # @param exit_code [Integer]
      def die(message, exit_code: 1)
        warn message
        exit exit_code
      end
    end
  end
end
