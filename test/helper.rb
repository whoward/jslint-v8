require "rubygems"
require 'test/unit'
require 'erb'

# require the library code
require File.expand_path("../lib/jslint-v8", File.dirname(__FILE__))

def erb_fixture(basename)
  ::ERB.new(File.read(erb_filename(basename))).result
end

def json_fixture(basename)
  File.read(json_filename(basename))
end

def erb_filename(basename)
  File.expand_path("fixtures/#{basename}.txt.erb", File.dirname(__FILE__))
end

def js_filename(basename)
  File.expand_path("fixtures/#{basename}.js", File.dirname(__FILE__))
end

def json_filename(basename)
  File.expand_path("fixtures/#{basename}.json", File.dirname(__FILE__))
end
