# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gemshine/version'

Gem::Specification.new do |spec|
  spec.name        = 'gemshine'
  spec.version     = Gemshine::VERSION
  spec.authors     = ['Nick Janetakis']
  spec.email       = ['nick.janetakis@gmail.com']
  spec.summary     = %q{Compare your ruby project's gem versions to their latest versions.}
  spec.description = %q{Enter a path and gemshine will recursively explore every ruby project and show you both the latest version and the current version of each gem in your Gemfile.}
  spec.homepage    = 'https://github.com/nickjj/gemshine'
  spec.license     = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'thor', '~> 0'
  spec.add_dependency 'terminal-table', '~> 1.4'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake', '~> 0'
  spec.add_development_dependency 'minitest', '~> 5.3'
end
