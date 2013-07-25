# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'SimControl/version'

Gem::Specification.new do |spec|
  spec.name          = "SimControl"
  spec.version       = SimControl::VERSION
  spec.authors       = ["Christian Schwartz"]
  spec.email         = ["christian.schwartz@gmail.com"]
  spec.description   = %q{A DSL for simpy based simulations on multiple hosts}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/cschwartz/SimControl"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
