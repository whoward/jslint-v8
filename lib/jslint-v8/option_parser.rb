require 'optparse'

module JSLintV8
   class OptionParser < ::OptionParser

      attr_reader :options

      def initialize
         super

         @options = {}
         @options[:lint_options] = {}

         self.version = JSLintV8::Version::STRING
         self.banner  = "#{self.banner} <filepattern>..."

         Runner::DefaultOptions.keys.each do |option|
            default = Runner::DefaultOptions[option] ? "on" : "off"

            long  = "--[no-]#{option}"
            desc  = "#{Runner::OptionDescriptions[option]} (default=#{default})"

            on(long, desc) do |value|
               options[:lint_options][option] = value
            end
         end

         on("-h", "--help", "Show this message") do
            STDERR.puts self.help
            exit(-1)
         end

         on("-v", "--version", "Show version") do
            STDERR.puts "#{self.program_name} version #{JSLintV8::Version::STRING}"
            exit(-1)
         end
      end
   end
end