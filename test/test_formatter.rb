require File.expand_path('helper', File.dirname(__FILE__))
require 'erb'
require 'stringio'

class TestFormatter < Test::Unit::TestCase

  def setup
    @output = String.new
    @output_stream = StringIO.new(@output, "w+")

    @formatter = JSLintV8::Formatter.new(@output_stream)
  end

  def test_create
    assert_equal @output_stream.object_id, @formatter.output_stream.object_id
  end

  def test_tick
    assert_equal "", @output

    @formatter.tick([])

    assert_equal ".", @output

    @formatter.tick(["foo"])

    assert_equal ".*", @output
  end

  def test_summary_with_no_errors
    @formatter.summary(%w(foo bar), {})

    assert_equal erb_fixture("formatter-summary-noerrors"), @output
  end

  def test_summary_with_errors
    error_1 = JSLintV8::LintError.new("line" => 42, "character" => 10, "reason" => "because i can")
    error_2 = JSLintV8::LintError.new("line" => 43, "character" => 3, "reason" => "a proof is not a proof")
    error_3 = JSLintV8::LintError.new("line" => 139, "character" => 12, "reason" => "undefined global 'foo'")

    result = {
      "foo" => [error_1, error_2],
      "bar" => [error_3]
    }

    @formatter.summary(%w(foo bar baz one two three), result)

    assert_equal erb_fixture("formatter-summary-errors"), @output
  end

end