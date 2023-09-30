# frozen_string_literal: true

require 'faraday'
require 'json'
require_relative 'tvdb_api_middleware'

class TVDBApi
  BASE_URL = 'https://api4.thetvdb.com'
  COMMON_PARAMS = { meta: 'translations', short: 'false' }.freeze
  ENDPOINTS = {
    search: '/v4/search',
    movie:  '/v4/movies/%{id}/extended',
    series: '/v4/series/%{id}/extended',
    person: '/v4/people/%{id}/extended'
  }.freeze

  DEFAULT_PARAMS = {
    movie: COMMON_PARAMS,
    series: COMMON_PARAMS
  }.freeze

  def initialize
    register_middleware
    setup_connection
  end

  def search(query)
    request(:search, query: query)
  end

  def search_by_type(query, type)
    request(:search, query: query, type: type)
  end

  def movie(id)
    request(:movie, id: id)
  end

  def series(id)
    request(:series, id: id)
  end

  def person(id)
    request(:person, id: id)
  end

  private

  def register_middleware
    Faraday::Request.register_middleware tvdb_auth: -> { TVDBAPIMiddleware }
  end

  def setup_connection
    @conn = Faraday.new(url: BASE_URL) do |faraday|
      faraday.headers['Content-Type'] = 'application/json'
      faraday.request :url_encoded
      faraday.request :tvdb_auth
      faraday.adapter Faraday.default_adapter
    end
  end

  def request(endpoint_key, params = {})
    url = ENDPOINTS[endpoint_key]
    raise "Invalid endpoint key: #{endpoint_key}" unless url

    default_params = DEFAULT_PARAMS[endpoint_key] || {}
    params = params.merge(default_params)

    url = url % params if url.include?('%{')

    response = @conn.get do |req|
      req.url url
      req.params = params.reject { |k, _| url.include?("%{#{k}}") }
    end

    JSON.parse(response.body)
  end
end

