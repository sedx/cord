# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cord/version'

Gem::Specification.new do |spec|
  spec.name          = 'cord'
  spec.version       = Cord::VERSION
  spec.authors       = ['Iliya Bondarenko']
  spec.email         = ['bondarenko.ik@gmai.com']

  spec.summary       = 'Easy way to wrap API Providers'
  spec.description   = 'Easy way to wrap API Providers'
  spec.homepage      = 'https://github.com/sedx/cord'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject{ |f| f.match(%r{^(test|spec|features)/})}
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_dependency 'hashie', '~> 3.4.3'
  spec.add_dependency 'faraday', '~> 0.9.1'
end
