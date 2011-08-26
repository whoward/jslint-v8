require File.expand_path('helper', File.dirname(__FILE__))

class TestRunner < Test::Unit::TestCase

  def setup
    @runner = JSLintV8::Runner.new(%w(foo bar))
  end

  def test_lint_library_filename
    assert File.exist? JSLintV8::Runner::JSLintLibraryFilename
  end

  def test_file_list
    assert_equal @runner.file_list, %w(foo bar)
  end

  def test_constructor_enumerable_wrapping
    @runner = JSLintV8::Runner.new("foo")

    assert_equal @runner.file_list, %w(foo)
  end

  def test_file_not_found
    assert_raise RuntimeError do
      @runner.run
    end
  end

  def test_file_found
    filename = js_filename "valid"

    assert_nothing_raised do
      JSLintV8::Runner.new(filename).run
    end
  end

  def test_runtime
    assert @runner.runtime.is_a?(V8::Context)
  end

  def test_runtime_caching
    first = @runner.runtime
    assert_equal @runner.runtime.object_id, first.object_id
  end

  def test_jslint_function_proxy
    assert_not_nil @runner.jslint_function
  end

  def test_jslint_result
    assert @runner.jslint_result.is_a?(Array)
  end

  def test_jslint_default_options
    assert @runner.jslint_options.keys.any?
  end

  def test_jslint_returns_array_of_errors
    result = @runner.jslint("if(true) alert('foo');")
    
    assert result.is_a?(Array)
    assert result.length > 0
    assert result.all? {|error| error.is_a?(JSLintV8::LintError) }
  end

  def test_run
    filename = js_filename("invalid")

    result = JSLintV8::Runner.new(filename).run

    assert result.is_a?(Hash)
    assert result.keys.include?(filename)
    assert result[filename].is_a?(Array)
  end

  def test_valid_run
    filename = js_filename("valid")

    result = JSLintV8::Runner.new(filename).run

    errors = result[filename]

    assert errors.nil?
  end

  def test_invalid_run
    filename = js_filename("invalid")

    result = JSLintV8::Runner.new(filename).run

    errors = result[filename]

    assert errors.any?
  end

  def test_defined_globals
    filename = js_filename("defined-globals")

    result = JSLintV8::Runner.new(filename).run

    errors = result[filename]

    assert errors.nil?
  end

  def test_defined_options
    filename = js_filename("defined-options")

    result = JSLintV8::Runner.new(filename).run

    errors = result[filename]

    assert errors.nil?
  end

  def test_block
    filename = js_filename("valid")

    count = 0

    JSLintV8::Runner.new(filename).run do |file, errors|
      count += 1

      if count == 1
        assert_equal file, filename
        assert_equal errors, []
      end
    end

    assert_equal count, 1
  end

  def test_rejects_successful
    valid_file = js_filename("valid")
    invalid_file = js_filename("invalid")

    result = JSLintV8::Runner.new([valid_file, invalid_file]).run

    assert_equal result.keys.length, 1
  end
end
