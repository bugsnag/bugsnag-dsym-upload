# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/bugsnag/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-bugsnag'
  spec.version       = Fastlane::Bugsnag::VERSION
  spec.author        = %q{Delisa Mason}
  spec.email         = %q{iskanamagus@gmail.com}

  spec.summary       = %q{Uploads dSYM files to Bugsnag}
  spec.homepage      = "https://github.com/bugsnag/bugsnag-dsym-upload"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(LICENSE.txt bugsnag-dsym-upload)
  spec.require_paths = ['lib']
  spec.test_files    = Dir["spec/**/*"]

  spec.add_runtime_dependency 'xml-simple'
  spec.add_runtime_dependency 'git'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'fastlane', '>= 2.28.5'
end
