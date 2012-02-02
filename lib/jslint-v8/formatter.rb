
module JSLintV8
   class Formatter
      attr_reader :output_stream
    
      def initialize(stream)
         @output_stream = stream
      end

      def tick(errors)
         output_stream.print(errors.any?? "*" : ".")
         output_stream.flush
      end

      def summary(tested_files, lint_result)
         if lint_result.keys.any?
            print_error_summary(lint_result)
            output_stream.print "\n"
         end

         print_count_summary(tested_files, lint_result)
      end

   private
      def print_error_summary(result) 
         out = output_stream

         out.print "\nFailures:\n\n"

         # we iterate the sorted keys to prevent a brittle test and also the output
         # should be nicer as it will be guaranteed to be alphabetized
         result.keys.sort.each do |file|
            errors = result[file]

            out.print "#{file}:\n"
            errors.each do |error|
               out.print "   line #{error.line_number} character #{error.character} #{error.reason}\n"
            end
         end
      end

      def print_count_summary(tested_files, lint_result)
         file_count = tested_files.length
         failure_count = lint_result.keys.length
         error_count = lint_result.values.flatten.length

         output_stream.print "#{file_count} files, #{failure_count} failures, #{error_count} errors\n"
      end

   end
end