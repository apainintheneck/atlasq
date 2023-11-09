# frozen_string_literal: true

require_relative "base"

module Atlasq
  module Command
    class Version < Base
      # @return [Boolean]
      def self.to_pager?
        false
      end

      # @return [String]
      def content
        VERSION
      end
    end
  end
end
