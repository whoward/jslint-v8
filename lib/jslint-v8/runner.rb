require 'v8'

module JSLintV8
   class Runner
      JSLintLibraryFilename = File.expand_path("js/jslint.js", File.dirname(__FILE__))

      attr_reader :file_list

      def initialize(files)
         if(files.is_a?(Array))
            @file_list = files
         else
            @file_list = [files]
         end
      end

      def run
         # make sure all files exit
         file_list.each do |file|
            raise "file not found: #{file}" unless File.exist?(file)
         end

         result = {}

         file_list.each do |file|
            errors = jslint(File.read(file))

            yield(file, errors) if block_given?

            next if errors.empty?

            result[file] = errors
         end

         result
      end
      
      def runtime
         @runtime ||= lambda do
            runtime = V8::Context.new

            # load the jslint library into the runtime
            runtime.eval(File.read JSLintLibraryFilename)

            # return the runtime
            runtime
         end.call
      end

      def jslint(source_code)
         jslint_function.call(source_code, jslint_options)
         jslint_result
      end

      def jslint_function
         runtime["JSLINT"];
      end

      def jslint_result
         runtime["JSLINT"]["errors"].to_a.compact.map do |error_object|
            JSLintV8::LintError.new(error_object)
         end
      end

      def jslint_options
         {
            "bitwise" => true,
            "eqeqeq" => true,
            "immed" => true,
            "newcap" => true,
            "nomen" => true,
            "onevar" => true,
            "plusplus" => true,
            "regexp" => true,
            "rhino" => true,
            "undef" => true,
            "white" => true
         }
      end

   end
end