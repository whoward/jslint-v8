
module JSLintV8
  class LintError
    attr_reader :line_number, :character, :reason, :evidence
  
    def initialize(jsobject)
      @line_number = jsobject["line"]
      @character = jsobject["character"]
      @reason = jsobject["reason"]
      @evidence = jsobject["evidence"]
    end

  end
end