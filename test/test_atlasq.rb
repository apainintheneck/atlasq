# frozen_string_literal: true

require "test_helper"
require "open3"

class AtlasqTest < Minitest::Test
  def test_version_number
    refute_nil ::Atlasq::VERSION
  end

  #
  # INTEGRATION
  #
  def executable_path
    @executable_path ||= File.expand_path("../exe/atlasq", __dir__)
  end

  def assert_command(args:, expected_stdout:, expected_stderr: "", expected_status: 0)
    stdout, stderr, status = Open3.capture3(executable_path, *args)

    assert_equal expected_status, status
    assert_equal expected_stderr, stderr
    assert_equal expected_stdout, stdout
  end

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
end
