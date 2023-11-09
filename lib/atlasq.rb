# frozen_string_literal: true

require_relative "atlasq/version"

module Atlasq
  class Error < StandardError; end
  DEBUG = ENV.key?("ATLASQ_DEBUG")

  autoload :Command, "atlasq/command"
  autoload :Shell, "atlasq/shell"
end
