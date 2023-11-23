# frozen_string_literal: true

require_relative "atlasq/version"

module Atlasq
  class Error < StandardError; end
  DEBUG = ENV.key?("ATLASQ_DEBUG")

  autoload :Command, "atlasq/command"
  autoload :Data, "atlasq/data"
  autoload :Format, "atlasq/format"
  autoload :PartialMatch, "atlasq/partial_match"
  autoload :Shell, "atlasq/shell"
  autoload :Util, "atlasq/util"

  def self.failed!
    @failed = true
  end

  def self.failed?
    !!@failed
  end
end
