# TVDB API

A simple Ruby gem to interface with the TVDB.org API, making it easy to search and fetch information about TV, films, actors etc.

## Installation

Add this line to your application's Gemfile:

  ```ruby
  gem 'tvdb_api'
  ```

And then execute:

  ```bash
  $ bundle install
  ```

Or install it yourself as:

  ```bash
  $ gem install tvdb_api
  ```

## Usage

Here are a few basic examples to get you started:

  ```ruby
  require 'tvdb_api'

  api = TVDBApi.new
  ```

### search

Searches TV Shows, Films, Actors, and People.

  ```ruby
  response = api.search('The Dark Knight')
  # Do something with the response
  ```

### search_series

  ```ruby
  response = api.search_series('The Simpsons')
  # Do something with the response
  ```

### search_films

  ```ruby
  response = api.search_films('Star Wars')
  # Do something with the response
  ```

### search_people

  ```ruby
  response = api.search_films('Martin Sheen')
  # Do something with the response
  ```

## Development

To set up the development environment, follow these steps:

1. Clone the repository:

  ```bash
  git clone https://github.com/your-username/tvdb_api.git
  ```

2. Change into the directory:

  ```bash
  cd tvdb_api_wrapper
  ```

3. Install dependencies:

  ```bash
  bundle install
  ```

### Running Tests

To run RSpec tests, execute the following:

  ```bash
  rspec
  ```

## Contributing

Bug reports and pull requests are welcome on GitHub at [here](https://github.com/swmcc/tvdb_api).

## License

The gem is available as open-source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

```
MIT License

Copyright (c) 2023 Stephen McCullough

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
