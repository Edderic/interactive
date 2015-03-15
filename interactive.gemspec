# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'interactive/version'

Gem::Specification.new do |spec|
  spec.name          = "interactive"
  spec.version       = Interactive::VERSION
  spec.authors       = ["Edderic Ugaddan"]
  spec.email         = ["edderic@gmail.com"]

  spec.summary       = %q{command-line helper, prints out questions and waits for valid responses}
  spec.homepage      = "http://github.com/Edderic/interactive"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'bundler'
end
