require File.expand_path('helper', File.dirname(__FILE__))
require 'erb'

class TestCli < Test::Unit::TestCase
  Executable = File.expand_path("../bin/jslint-v8", File.dirname(__FILE__))
  
  def test_executable_exists
    assert File.exist?(Executable)
  end

  def test_empty_args
    # capture standard error by redirecting it to standard out
    result = `#{Executable} 2>&1`

    assert_match /^Usage/, result
    assert_equal 255, $?.exitstatus
  end

  def test_version_output
    # capture standard error by redirecting it to standard out
    result = `#{Executable} -v 2>&1`

    assert_equal erb_fixture("version-output"), result
    assert_equal 255, $?.exitstatus
  end

  def test_help_output
    # capture standard error by redirecting it to standard out
    result = `#{Executable} -h foo.js bar.js baz.js 2>&1`

    assert_match /^Usage/, result
    assert_equal 255, $?.exitstatus
  end

  def test_only_options_given
    # capture standard error by redirecting it to standard out
    result = `#{Executable} --browser --jquery 2>&1`

    assert_match /^Usage/, result
    assert_equal 255, $?.exitstatus
  end

  def test_valid
    result = %x{#{Executable} "#{js_filename "valid"}"}

    assert $?.success?
    assert_equal erb_fixture("cli-valid-expected-output"), result
  end

  def test_invalid
    result = %x{#{Executable} "#{js_filename "invalid"}"}

    assert_equal false, $?.success?
    assert_equal erb_fixture("cli-invalid-expected-output"), result
  end

  def test_suite
    defined_globals = js_filename("defined-globals")
    defined_options = js_filename("defined-options")
    invalid = js_filename("invalid")
    valid = js_filename("valid")
    forloop = js_filename("forloop")

    result = %x{#{Executable} "#{defined_globals}" "#{defined_options}" "#{forloop}" "#{invalid}" "#{valid}" }

    assert_equal false, $?.success?
    assert_equal erb_fixture("cli-suite-expected-output"), result
  end

end