# frozen_string_literal: true

require_relative 'lib/tvdb_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'tvdb_api'
  spec.version       = TVDB::VERSION
  spec.authors       = ['Stephen McCullough']
  spec.email         = ['me@swm.cc']

  spec.summary       = 'A Ruby wrapper for the TVDB.org API v4'
  spec.description   = 'Provides a convenient way to interact with the TVDB API v4, ' \
                       'including searching for TV series, movies, and people.'
  spec.homepage      = 'https://github.com/swmcc/tvdb_api'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 3.2'

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/swmcc/tvdb_api/issues',
    'changelog_uri' => 'https://github.com/swmcc/tvdb_api/releases',
    'source_code_uri' => 'https://github.com/swmcc/tvdb_api',
    'homepage_uri' => spec.homepage,
    'rubygems_mfa_required' => 'true'
  }

  spec.files = Dir.chdir(__dir__) do
    Dir['{lib}/**/*', 'VERSION', 'LICENSE.txt', 'README.md']
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '>= 1.0', '< 3.0'
  spec.add_dependency 'json', '~> 2.0'
end
