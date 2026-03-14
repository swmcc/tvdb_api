# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-03-14

### Added
- `TVDB` module namespace with `TVDB::Client` as the main API client
- Custom error classes: `TVDB::Error`, `TVDB::AuthenticationError`, `TVDB::ConfigurationError`, `TVDB::APIError`
- Support for explicit credentials via initializer: `TVDB::Client.new(api_token: '...', pin: '...')`
- `search_by_type` method for filtered searches
- Expanded test coverage (18 examples)
- Makefile with development targets
- CHANGELOG

### Changed
- Restructured codebase with proper module namespacing
- Moved middleware to `TVDB::Middleware::Authentication`
- Development dependencies now in Gemfile (modern gem convention)
- Updated gemspec with additional metadata URIs
- Faraday dependency now supports both 1.x and 2.x

### Fixed
- URL interpolation bug where `%<id>s` format specifiers were not being processed

### Deprecated
- `TVDBApi` class name (use `TVDB::Client` instead, alias provided for backwards compatibility)
- `TVDBAPIMiddleware` class name (use `TVDB::Middleware::Authentication` instead)

## [0.0.5] - 2024-01-15

### Changed
- Updated VERSION and fixed DEFAULT_PARAMS in TVDBApi class

## [0.0.4] - 2024-01-10

### Changed
- Code improvements and optimizations

[0.1.0]: https://github.com/swmcc/tvdb_api/compare/v0.0.5...v0.1.0
[0.0.5]: https://github.com/swmcc/tvdb_api/compare/v0.0.4...v0.0.5
[0.0.4]: https://github.com/swmcc/tvdb_api/releases/tag/v0.0.4
