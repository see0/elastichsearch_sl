# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elasticsearch_sl/version'

Gem::Specification.new do |spec|
  spec.name          = "elasticsearch_sl"
  spec.version       = ElasticsearchSl::VERSION
  spec.authors       = ["Jason See"]
  spec.email         = ["jason@jasonsee.me"]
  spec.summary       = "Elastic Search Awesome DSL"
  spec.description   = "Elastic Search Awesome DSL extaracted from Tire and upgraded to 1.0"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_dependency "hashie"
  spec.add_dependency "json"
end
