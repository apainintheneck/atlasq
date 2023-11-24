# frozen_string_literal: true

require "unaccent"

module Atlasq
  module Util
    module String
      # @param string [#to_s]
      # @return [String]
      def self.titleize(string)
        string
          .to_s
          .split(/[-_ \t]+/)
          .map(&:capitalize)
          .join(" ")
      end

      # Make string lowercase and remove accents.
      #
      # @param string [String]
      # @return [String]
      def self.normalize(string)
        @normalize ||= {}
        @normalize[string] ||= Unaccent.unaccent(string.downcase)
      end
    end
  end
end
