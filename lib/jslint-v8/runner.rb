require 'v8'

module JSLintV8
   class Runner
      JSLintLibraryFilename = File.expand_path("js/jslint.js", File.dirname(__FILE__))

      DefaultOptions =  {
         "asi" => false,
         "bitwise" => true,
         "boss" => false,
         "browser" => false,
         "couch" => false,
         "curly" => false,
         "debug" => false,
         "devel" => false,
         "dojo" => false,
         "eqeqeq" => true,
         "eqnull" => false,
         "es5" => false,
         "evil" => false,
         "expr" => false,
         "forin" => false,
         "globalstrict" => false,
         "immed" => true,
         "jquery" => false,
         "latedef" => false,
         "laxbreak" => false,
         "loopfunc" => false,
         "mootools" => false,
         "newcap" => true,
         "noarg" => false,
         "node" => false,
         "noempty" => false,
         "nonew" => false,
         "nomen" => true,
         "onevar" => true,
         "passfail" => false,
         "plusplus" => true,
         "prototypejs" => false,
         "regexdash" => false,
         "regexp" => true,
         "rhino" => false,
         "undef" => true,
         "scripturl" => false,
         "shadow" => false,
         "strict" => false,
         "sub" => false,
         "supernew" => false,
         "trailing" => false,
         "white" => false,
         "wsh" => false
      }.freeze

      OptionDescriptions =  {
         "asi"          => "if automatic semicolon insertion should be tolerated",
         "bitwise"      => "if bitwise operators should not be allowed",
         "boss"         => "if advanced usage of assignments should be allowed",
         "browser"      => "if the standard browser globals should be predefined",
         "couch"        => "if CouchDB globals should be predefined",
         "curly"        => "if curly braces around blocks should be required (even in if/for/while)",
         "debug"        => "if debugger statements should be allowed",
         "devel"        => "if logging globals should be predefined (console, alert, etc.)",
         "dojo"         => "if Dojo Toolkit globals should be predefined",
         "eqeqeq"       => "if === should be required",
         "eqnull"       => "if == null comparisons should be tolerated",
         "es5"          => "if ES5 syntax should be allowed",
         "evil"         => "if eval should be allowed",
         "expr"         => "if ExpressionStatement should be allowed as Programs",
         "forin"        => "if for in statements must filter",
         "globalstrict" => "if global \"use strict\"; should be allowed (also enables 'strict')",
         "immed"        => "if immediate invocations must be wrapped in parens",
         "jquery"       => "if jQuery globals should be predefined",
         "latedef"      => "if the use before definition should not be tolerated",
         "laxbreak"     => "if line breaks should not be checked",
         "loopfunc"     => "if functions should be allowed to be defined within loops",
         "mootools"     => "if MooTools globals should be predefined",
         "newcap"       => "if constructor names must be capitalized",
         "noarg"        => "if arguments.caller and arguments.callee should be disallowed",
         "node"         => "if the Node.js environment globals should be predefined",
         "noempty"      => "if empty blocks should be disallowed",
         "nonew"        => "if using `new` for side-effects should be disallowed",
         "nomen"        => "if names should be checked",
         "onevar"       => "if only one var statement per function should be allowed",
         "passfail"     => "if the scan should stop on first error",
         "plusplus"     => "if increment/decrement should not be allowed",
         "prototypejs"  => "if Prototype and Scriptaculous globals should be predefined",
         "regexdash"    => "if unescaped last dash (-) inside brackets should be tolerated",
         "regexp"       => "if the . should not be allowed in regexp literals",
         "rhino"        => "if the Rhino environment globals should be predefined",
         "undef"        => "if variables should be declared before used",
         "scripturl"    => "if script-targeted URLs should be tolerated",
         "shadow"       => "if variable shadowing should be tolerated",
         "strict"       => "require the \"use strict\"; pragma",
         "sub"          => "if all forms of subscript notation are tolerated",
         "supernew"     => "if `new function () { ... };` and `new Object;` should be tolerated",
         "trailing"     => "if trailing whitespace rules apply",
         "white"        => "if strict whitespace rules apply",
         "wsh"          => "if the Windows Scripting Host environment globals should be predefined",
      }.freeze

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
         runtime["JSHINT"];
      end

      def jslint_result
         runtime["JSHINT"]["errors"].to_a.compact.map do |error_object|
            JSLintV8::LintError.new(error_object)
         end
      end

      def jslint_options
         @jslint_options ||= DefaultOptions.dup
      end

   end
end