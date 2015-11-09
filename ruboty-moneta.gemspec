# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruboty/moneta/version'

Gem::Specification.new do |spec|
  spec.name          = "ruboty-moneta"
  spec.version       = Ruboty::Moneta::VERSION
  spec.authors       = ["akira.takahashi"]
  spec.email         = ["rike422@gmail.com"]

  spec.summary       = %q{Store Ruboty's memory via Moneta}
  spec.description   = %q{Store Ruboty's memory via Moneta}
  spec.homepage      = "https://github.com/rike422/ruboty-moneta"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]


  spec.add_runtime_dependency "ruboty"
  spec.add_dependency "moneta", "~> 0.8.0"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
