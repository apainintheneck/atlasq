# frozen_string_literal: true

require_relative "atlasq/version"

module Atlasq
  class Error < StandardError; end

  autoload :Command, "atlasq/command"
  autoload :Shell, "atlasq/shell"
end
