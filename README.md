<p align="center">
  <img src="https://raw.githubusercontent.com/swmcc/tvdb_api/main/assets/header.svg" alt="tvdb_api" width="800">
</p>

<p align="center">
  <a href="https://rubygems.org/gems/tvdb_api"><img src="https://img.shields.io/gem/v/tvdb_api.svg" alt="Gem Version"></a>
  <a href="https://github.com/swmcc/tvdb_api/actions"><img src="https://github.com/swmcc/tvdb_api/workflows/CI/badge.svg" alt="CI Status"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT"></a>
</p>

---

A simple Ruby gem to interface with the TVDB.org API, making it easy to search and fetch information about TV series, films, and people.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tvdb_api'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install tvdb_api
```

## Configuration

Set the following environment variables:

```bash
export TVDB_API_TOKEN=your_api_key
export TVDB_PIN=your_pin
```

## Usage

```ruby
require 'tvdb_api'

api = TVDBApi.new
```

### Search

Search across TV shows, films, and people:

```ruby
response = api.search('The Dark Knight')
```

### Search by Type

Filter search results by type:

```ruby
# Search for series only
response = api.search_by_type('The Simpsons', 'series')

# Search for movies only
response = api.search_by_type('Star Wars', 'movie')
```

### Get Movie Details

```ruby
response = api.movie(12879)
```

### Get Series Details

```ruby
response = api.series(75299)
```

### Get Person Details

```ruby
response = api.person(256583)
```

## Development

### Prerequisites

- Ruby >= 3.2
- Bundler

### Setup

```bash
git clone https://github.com/swmcc/tvdb_api.git
cd tvdb_api
make install
```

### Make Targets

| Target | Description |
|--------|-------------|
| `make install` | Install dependencies |
| `make console` | Start interactive Ruby console with gem loaded |
| `make test` | Run all tests |
| `make test.focus` | Run tests with focus tag |
| `make lint` | Run RuboCop linter |
| `make lint.fix` | Auto-fix RuboCop offenses |
| `make check` | Run all checks (lint + test) |
| `make build` | Build the gem |
| `make clean` | Remove built gems |
| `make help` | Show all available targets |

### Running Tests

```bash
make test

# or run a specific test file
bundle exec rspec spec/tvdb_api_spec.rb

# or run a specific test by line number
bundle exec rspec spec/tvdb_api_spec.rb:27
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/swmcc/tvdb_api](https://github.com/swmcc/tvdb_api).

## License

The gem is available as open-source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
