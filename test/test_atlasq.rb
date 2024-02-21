# frozen_string_literal: true

require "test_helper"
require "open3"

class AtlasqTest < Minitest::Test
  # @return [String] absolute path to atlasq executable
  def executable_path
    @executable_path ||= File.expand_path("../exe/atlasq", __dir__)
  end

  # Run an atlasq command and check the results
  #
  # @param args [Array<String>]
  # @param expected_stdout [String]
  # @param expected_stderr [String]
  # @param expected_status [Integer]
  def assert_command(args:, expected_stdout: "", expected_stderr: "", expected_status: 0)
    stdout, stderr, status = Open3.capture3(executable_path, *args)

    assert_equal expected_stdout, stdout
    assert_equal expected_stderr, stderr
    assert_equal expected_status, status.exitstatus
  end

  #
  # VERSION
  #
  def test_version_number
    refute_nil ::Atlasq::VERSION
  end

  #
  # INTEGRATION
  #
  def test_usage
    expected_output = <<~OUTPUT
      atlasq -- a utility to query country info

      usage:
        atlasq query...
        atlasq [command] query...
        atlasq -h/--help
        atlasq -v/--version

      commands:
        -c/--country : find countries
        -r/--region  : find countries by region
        -m/--money   : find countries by currency
    OUTPUT

    assert_command args: [], expected_stdout: expected_output
  end

  def test_help
    stdout, stderr, status = Open3.capture3(executable_path, "-h")

    refute_empty stdout
    assert_empty stderr
    assert_equal 0, status.exitstatus
  end

  def test_country_success
    expected_output = <<~OUTPUT
      *
      * Country: The Republic of Chile
      * * * * * * * * * * * * * * * * * *
      (🇨🇱 | 152 | CL | CHL | Chile)
       | Languages: Spanish; Castilian
        | Nationality: Chilean
         | Region: South America
          | Continent: South America
           | Currency: $ Chilean Peso
            |________________________________________
    OUTPUT

    [
      %w[chile],
      %w[-c chile],
    ].each do |args|
      assert_command args: args, expected_stdout: expected_output
    end
  end

  def test_country_failure
    assert_command args: %w[-c atlantis],
                   expected_stdout: "Unknown country: atlantis\n",
                   expected_status: 1
  end

  def test_region_success
    expected_output = <<~OUTPUT
      *
      * Region: Australia and New Zealand
      * * * * * * * * * * * * * * * * * * *
      (🇦🇺 | 036 | AU | AUS | Australia)
      (🇨🇨 | 166 | CC | CCK | Cocos (Keeling) Islands)
      (🇨🇽 | 162 | CX | CXR | Christmas Island)
      (🇳🇫 | 574 | NF | NFK | Norfolk Island)
      (🇳🇿 | 554 | NZ | NZL | New Zealand)
    OUTPUT

    [
      ["australia and new zealand"],
      ["-r", "australia and new zealand"],
    ].each do |args|
      assert_command args: args, expected_stdout: expected_output
    end
  end

  def test_region_failure
    assert_command args: %w[-r Pyrrus],
                   expected_stdout: "Unknown region: pyrrus\n",
                   expected_status: 1
  end

  def test_currency_success
    expected_output = <<~OUTPUT
      *
      * Currency: [CAD] $ Canadian Dollar
      * * * * * * * * * * * * * * * * * * *
      (🇨🇦 | 124 | CA | CAN | Canada)
    OUTPUT

    [
      ["canadian dollar"],
      ["-m", "canadian dollar"],
    ].each do |args|
      assert_command args: args, expected_stdout: expected_output
    end
  end

  def test_currency_failure
    assert_command args: ["-m", "Double Dollars"],
                   expected_stdout: "Unknown currency: double dollars\n",
                   expected_status: 1
  end

  def test_language_success
    expected_output = <<~OUTPUT
      *
      * Language: (gn/grn) Guarani
      * * * * * * * * * * * * * * * *
      (🇦🇷 | 032 | AR | ARG | Argentina)
      (🇵🇾 | 600 | PY | PRY | Paraguay)
    OUTPUT

    [
      ["grn"],
      ["-l", "grn"],
    ].each do |args|
      assert_command args: args, expected_stdout: expected_output
    end
  end

  def test_language_failure
    assert_command args: ["-l", "Vulcan"],
                   expected_stdout: "Unknown language: vulcan\n",
                   expected_status: 1
  end

  def test_any_failure
    assert_command args: ["Grand Line"],
                   expected_stdout: "Unknown search term: grand line\n",
                   expected_status: 1
  end
end
