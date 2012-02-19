[![Build Status](https://secure.travis-ci.org/whoward/jslint-v8.png)](http://travis-ci.org/whoward/jslint-v8)

# Description

jslint-v8 is simply a ruby wrapper that helps you run JSHint as an automated
code quality standards tool inside your projects.  It's geared towards being run
in a continuous integration process (CI), such as Jenkins.

While it is focused on Ruby projects it can just as easily be used for any other 
language out there so long as you have Ruby installed on your system.

Like it's name implies we run JSHint on the JavaScript V8 interpreter so, in 
other words, it runs really really fast.

# How to use

1. Make sure you have Ruby and Rubygems installed on your computer (most operating systems except for Windows have this already)

2. In your console run: ```gem install jslint-v8```

3. Run the following command ```jslint-v8 path/to/file.js```

For full details on using the command line interface simply type ```jslint-v8 --help``` into your console

# Default options

You can see which options are enabled by default by examining the output of ```jslint-v8 --help```

# Rake Task

In addition to the CLI you can also set up a Rake task to automatically run against
a set of files.  Inside your Rakefile add the following:

```ruby
   require 'rake'
   require 'jslint-v8'

   namespace :js do
      JSLintV8::RakeTask.new do |task|
         task.name = "lint"
         task.description = "runs jslint against all important javascript files"
         
         task.output_stream = STDOUT
         
         task.include_pattern = "app/javascripts/**/*.js"
         task.exclude_pattern = "app/javascripts/{generated,lib}/**/*.js"
         
         # pass boolean options to jshint like this, these are merged with the default options
         task.jquery  = true  # predefine jQuery globals
         task.browser = true  # predefine Browser globals
         task.bitwise = false # allow bitwise operators to be used
         
         # or just access the options hash directly, be sure to use strings for keys
         task.lint_options["strict"] = true
      end
   end
```

Modify the above as needed.

The code above:

- generates a rake task named "js:lint" with the given description 
- write results to standard output (STDOUT)
- run against all javascript files under ```app/javascripts``` except under ```app/javascripts/lib``` and ```app/javascripts/generated```
- runs with all the default jshint options enabled except bitwise, but also enabling strict, jquery and browser

# Contributing

Whatever works, but my preference is for you to fork this repository on github
and write your changes on a separate branch.  When finished you can send them
to me by issuing a pull request.

# Feature Requests / Suggestions

You can open up an Issue here on Github or if you'd prefer send me a message 
here on Github, please try and give me a good use case for your feature request / suggestion.