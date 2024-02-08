# frozen_string_literal: true

version = File.read(File.expand_path("VERSION", __dir__)).strip

Gem::Specification.new do |spec|
  spec.name          = 'tvdb_api'
  spec.version       = version
  spec.summary       = 'A Ruby wrapper for the TVDB.org API'
  spec.description   = 'Provides a convenient way to interact with the TVDB API.'
  spec.author        = ['Stephen McCullough']
  spec.email         = ['me@swm.cc']
  spec.homepage      = 'https://github.com/swmcc/tvdb_api'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*']
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 1.0'
  spec.add_dependency 'json', '~> 2.0'

  spec.add_development_dependency 'brakeman', '~> 6.1'
  spec.add_development_dependency 'rubocop', '~> 1.60'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 3.19'
end
