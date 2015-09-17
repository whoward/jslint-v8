require 'json'

module JSLintV8
  class Json
    attr_reader :output_stream

    def initialize(stream)
      @output_stream = stream
    end

    def tick(errors)
    end

    def summary(tested_files, lint_result)
      if lint_result.keys.any?
        output = lint_result.map do |file_errors|
          { file_errors[0] =>
              file_errors[1].map do |errors|
                { "line" => errors.line_number,
                  "column" => errors.character,
                  "reason" => errors.reason,
                  "evidence" => errors.evidence
                }
              end
          }
        end
        print_error_summary(output)
      end
    end

  private

    def print_error_summary(result)
      out = output_stream
      out.print JSON.dump(result)
    end

  end
end
