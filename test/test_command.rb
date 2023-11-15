# frozen_string_literal: true

require "test_helper"

class CommandTest < Minitest::Test
  #
  # ARG PARSING
  #
  def command_args
    %w[one two three]
  end

  def test_parse_country
    %w[-c --country --countries].each do |command|
      result = Atlasq::Command::Options.new(
        command: Atlasq::Command::Country,
        args: command_args
      )
      args = [command] + command_args

      assert_equal result, Atlasq::Command.parse(args)
    end
  end

  def test_parse_region
    %w[-r --region --regions].each do |command|
      result = Atlasq::Command::Options.new(
        command: Atlasq::Command::Region,
        args: command_args
      )
      args = [command] + command_args

      assert_equal result, Atlasq::Command.parse(args)
    end
  end

  def test_parse_money
    %w[-m --money].each do |command|
      result = Atlasq::Command::Options.new(
        command: Atlasq::Command::Money,
        args: command_args
      )
      args = [command] + command_args

      assert_equal result, Atlasq::Command.parse(args)
    end
  end

  def test_parse_version
    %w[-m --money].each do |command|
      result = Atlasq::Command::Options.new(
        command: Atlasq::Command::Money,
        args: command_args
      )
      args = [command] + command_args

      assert_equal result, Atlasq::Command.parse(args)
    end
  end

  def test_parse_help
    %w[-h --help].each do |command|
      result = Atlasq::Command::Options.new(
        command: Atlasq::Command::Help,
        args: command_args
      )
      args = [command] + command_args

      assert_equal result, Atlasq::Command.parse(args)
    end
  end

  def test_parse_usage
    result = Atlasq::Command::Options.new(
      command: Atlasq::Command::Usage,
      args: command_args
    )
    args = [nil] + command_args

    assert_equal result, Atlasq::Command.parse(args)
  end

  def test_parse_any
    %w[France Europe Euro].each do |command|
      args = [command] + command_args
      result = Atlasq::Command::Options.new(
        command: Atlasq::Command::Any,
        args: args
      )

      assert_equal result, Atlasq::Command.parse(args)
    end
  end
end
