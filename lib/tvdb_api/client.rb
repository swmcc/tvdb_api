# frozen_string_literal: true

require 'faraday'
require 'json'

module TVDB
  class Client
    BASE_URL = 'https://api4.thetvdb.com'

    ENDPOINTS = {
      search: '/v4/search',
      movie: '/v4/movies/%<id>s/extended',
      series: '/v4/series/%<id>s/extended',
      person: '/v4/people/%<id>s/extended'
    }.freeze

    DEFAULT_PARAMS = {
      movie: { meta: 'translations', short: 'false' },
      series: { meta: 'translations', short: 'false' }
    }.freeze

    def initialize(api_token: nil, pin: nil)
      @api_token = api_token
      @pin = pin
      @connection = build_connection
    end

    def search(query)
      get(:search, query:)
    end

    def search_by_type(query, type)
      get(:search, query:, type:)
    end

    def movie(id)
      get(:movie, id:)
    end

    def series(id)
      get(:series, id:)
    end

    def person(id)
      get(:person, id:)
    end

    private

    attr_reader :connection, :api_token, :pin

    def build_connection
      Faraday.new(url: BASE_URL) do |f|
        f.headers['Content-Type'] = 'application/json'
        f.headers['Accept'] = 'application/json'
        f.request :tvdb_auth, api_token: api_token, pin: pin
        f.request :url_encoded
        f.adapter Faraday.default_adapter
      end
    end

    def get(endpoint_key, params = {})
      endpoint = ENDPOINTS.fetch(endpoint_key) do
        raise ArgumentError, "Unknown endpoint: #{endpoint_key}"
      end

      url = build_url(endpoint, params)
      query_params = build_query_params(endpoint_key, params)

      response = connection.get(url, query_params)
      parse_response(response)
    end

    def build_url(endpoint, params)
      return endpoint unless endpoint.include?('%<')

      format(endpoint, params)
    end

    def build_query_params(endpoint_key, params)
      defaults = DEFAULT_PARAMS[endpoint_key] || {}
      params.except(:id).merge(defaults)
    end

    def parse_response(response)
      body = JSON.parse(response.body)

      return body if response.success?

      raise TVDB::APIError.new(body['message'] || 'API request failed', response)
    end
  end
end
