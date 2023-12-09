# frozen_string_literal: true

require "json"

module Atlasq
  module Cache
    CACHE_DIR = File.expand_path("../../cache", __dir__).freeze
    private_constant :CACHE_DIR

    def self.get(name, namespace:)
      @get ||= {}
      @get.fetch([namespace, name]) do
        path = "#{CACHE_DIR}/#{namespace}/#{name}.json"
        content = File.read(path)
        JSON.parse(content)
      end
    end
  end
end
