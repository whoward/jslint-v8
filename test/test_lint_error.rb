require File.expand_path('helper', File.dirname(__FILE__))

class TestLintError < Test::Unit::TestCase

  def setup
    @object = {
      "line" => 42,
      "character" => 10,
      "reason" => "because i can",
      "evidence" => "I don't know, a proof is a proof. What kind of a proof? It's a proof. A proof is a proof, and when you have a good proof, it's because it's proven."
    }

    @error = JSLintV8::LintError.new(@object)
  end

  def test_line_number
    assert_equal @error.line_number, 42
  end

  def test_character
    assert_equal @error.character, 10
  end

  def test_reason
    assert_equal @error.reason, "because i can"
  end

  def test_evidence
    assert_equal @error.evidence, "I don't know, a proof is a proof. What kind of a proof? It's a proof. A proof is a proof, and when you have a good proof, it's because it's proven."
  end

end