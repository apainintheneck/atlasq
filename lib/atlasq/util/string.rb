# frozen_string_literal: true

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
    end
  end
end
