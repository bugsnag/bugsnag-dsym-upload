# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/bugsnag/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-bugsnag'
  spec.version       = Fastlane::Bugsnag::VERSION
  spec.author        = %q{Bugsnag}
  spec.email         = %q{support@bugsnag.com}

  spec.summary       = %q{Uploads dSYM files to Bugsnag}
  spec.homepage      = "https://github.com/bugsnag/bugsnag-upload"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(LICENSE.txt bugsnag-dsym-upload)
  spec.require_paths = ['lib']
  spec.test_files    = Dir["spec/**/*"]

  spec.add_runtime_dependency 'xml-simple', '~> 1'
  spec.add_runtime_dependency 'git', '~> 1'

  spec.add_development_dependency 'pry', '~> 0'
  spec.add_development_dependency 'bundler', '~> 2'
  spec.add_development_dependency 'rspec', '~> 3'
  spec.add_development_dependency 'rake', '~> 13'
  spec.add_development_dependency 'rubocop', '~> 0'
  spec.add_development_dependency 'fastlane', '>= 2.28.5', '< 3.0'
end
