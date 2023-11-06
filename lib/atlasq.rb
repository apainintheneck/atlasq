# frozen_string_literal: true

require_relative "atlasq/version"

module Atlasq
  class Error < StandardError; end

  autoload :command, "atlasq/command"
  autoload :shell, "atlasq/shell"
end
