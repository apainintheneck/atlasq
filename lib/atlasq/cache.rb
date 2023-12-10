# frozen_string_literal: true

require "json"

module Atlasq
  module Cache
    CACHE_DIR = File.expand_path("../../cache", __dir__).freeze
    private_constant :CACHE_DIR

    # @param full_name [String] namespace + file name (ex. "info/countries.json")
    # @return file
    def self.get(full_name)
      @get ||= {}
      @get.fetch(full_name) do
        path = "#{CACHE_DIR}/#{full_name}"
        content = File.read(path)

        case full_name
        when /\.json$/
          JSON.parse(content)
        else
          content
        end
      end
    end
  end
end
