require 'rake'
require 'rake/tasklib'

module JSLintV8
  class RakeTask < ::Rake::TaskLib
    # name of the rake task
    attr_accessor :name

    # description for the task
    attr_accessor :description

    # inclusion glob pattern for files
    attr_accessor :include_pattern

    # exclusion glob pattern for files
    attr_accessor :exclude_pattern

    # output stream for this task
    attr_accessor :output_stream

    # custom lint options for the task
    attr_accessor :lint_options

    # metaprogrammatically define accessors for each lint option expected
    Runner::DefaultOptions.keys.each do |key|
      define_method(key)       { lint_options[key] }
      define_method("#{key}=") {|value| lint_options[key] = value }
    end

    def initialize
      # a default name
      @name = "lint"
      
      # a default description
      @description = "Runs the JSLint Test Suite"

      # by default a glob pattern that will include javascript files found in rails
      @include_pattern = "app/javascripts/**/*.js"

      # by default a glob pattern which will match no files
      @exclude_pattern = ""

      # by default use standard output for writing information
      @output_stream = STDOUT

      # by default provide no overridden lint options
      @lint_options = {}

      # if a block was given allow the block to call elements on this object
      yield self if block_given?

      # create the rake task
      new_task = task(name) do
        formatter = JSLintV8::Formatter.new(output_stream)

        lint_result = runner.run do |file, errors|
          formatter.tick(errors)
        end

        # put a separator line in between the ticks and any summary
        output_stream.print "\n"

        # print a summary of failed files
        formatter.summary(files_to_run, lint_result)

        # raise an exception if there are errors
        raise "jslint suite failed" unless lint_result.empty?
      end
      
      # assign the description to the rake task
      new_task.comment = description
    end

    #
    # Returns a list of all files to run, sorted
    #
    def files_to_run
      included_files = Dir.glob(include_pattern)
      excluded_files = Dir.glob(exclude_pattern)

      (included_files - excluded_files).sort
    end

  private
    
    def runner
      runner = JSLintV8::Runner.new(files_to_run)
      runner.jslint_options.merge!(lint_options)
      runner
    end

  end
end