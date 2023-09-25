# frozen_string_literal: true

require 'faraday'
require 'json'
require_relative 'tvdb_api_middleware'

class TVDBApi
  BASE_URL = 'https://api4.thetvdb.com'
  ENDPOINTS = {
    search: '/v4/search',
    movie: '/v4/movies/%{id}/extended',
    series: '/v4/series/%{id}/extended',
    person: '/v4/people/%{id}/extended'
  }

  def initialize
    Faraday::Request.register_middleware tvdb_auth: -> { TVDBAPIMiddleware }

    @conn = Faraday.new(url: BASE_URL) do |faraday|
      faraday.headers['Content-Type'] = 'application/json'
      faraday.request :url_encoded
      faraday.request :tvdb_auth
      faraday.adapter Faraday.default_adapter
    end
  end

  def search(query)
    request_endpoint(:search, { query: })
  end

  def search_people(query)
    request_endpoint(:search, { query:, type: 'person' })
  end

  def search_series(query)
    request_endpoint(:search, { query:, type: 'series' })
  end

  def search_movies(query)
    request_endpoint(:search, { query:, type: 'movie' })
  end

  def movie(id)
    request_endpoint(:movie, { id: })
  end

  def series(id)
    request_endpoint(:series, { id: })
  end

  def person(id)
    request_endpoint(:person, { id: })
  end

  private

  def request_endpoint(endpoint_key, params = {})
    url = ENDPOINTS[endpoint_key]
    raise "Invalid endpoint key: #{endpoint_key}" unless url

    url = url % params if url.include?('%{')

    response = @conn.get do |req|
      req.url url
      req.params = params
    end

    JSON.parse(response.body)
  end
end
