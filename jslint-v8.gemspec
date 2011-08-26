# -*- encoding: utf-8 -*-
require File.expand_path("lib/jslint-v8/version", File.dirname(__FILE__))

Gem::Specification.new do |s|
  s.name = %q{jslint-v8}
  s.version = JSLintV8::Version::STRING
  s.platform = Gem::Platform::RUBY

  s.authors = ["William Howard"]
  s.email = %q{whoward.tke@gmail.com}
  s.homepage = %q{http://github.com/whoward/jslint-v8}

  s.default_executable = %q{jslint-v8}
  s.executables = ["jslint-v8"]

  s.extra_rdoc_files = ["README.markdown"]

  s.require_paths = ["lib"]

  s.summary = %q{JSLint CLI and rake tasks via therubyracer (JavaScript V8 gem)}
  s.description = "Ruby gem wrapper for a jslint cli.  Uses the The Ruby Racer library for performance reasons targeted for usage in CI environments and backed up with a full test suite."  
  
  s.files = Dir.glob("lib/**/*.rb") + Dir.glob("lib/**/*.js") + %w(Gemfile Gemfile.lock bin/jslint-v8)
  s.test_files = Dir.glob("test/**/*.rb")

  s.add_dependency "therubyracer", "~> 0.9.4"
  s.add_development_dependency "rake"
  s.add_development_dependency "test-unit"
end

