# frozen_string_literal: true

require 'faraday'
require 'json'
require_relative 'tvdb_api_middleware'

class TVDBApi

  BASE_URL = 'https://api4.thetvdb.com'
  ENDPOINTS = {
    search: '/v4/search',
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
    request_endpoint(:search, { query: query })
  end

  def search_people(query)
    request_endpoint(:search, { query: query, type: 'person' })
  end

  def search_series(query)
    request_endpoint(:search, { query: query, type: 'series' })
  end

  def search_movies(query)
    request_endpoint(:search, { query: query, type: 'movie' })
  end

  private

  def request_endpoint(endpoint_key, params = {})
    url = ENDPOINTS[endpoint_key]
    raise "Invalid endpoint key: #{endpoint_key}" unless url

    response = @conn.get do |req|
      req.url url
      req.params = params
    end

    JSON.parse(response.body)
  end
end
