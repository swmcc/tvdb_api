# frozen_string_literal: true

require 'faraday'
require 'json'

module TVDB
  module Middleware
    class Authentication < Faraday::Middleware
      LOGIN_URL = 'https://api4.thetvdb.com/v4/login'

      def initialize(app, api_token: nil, pin: nil)
        super(app)
        @api_token = api_token
        @pin = pin
        @bearer_token = nil
      end

      def call(env)
        env[:request_headers]['Authorization'] = "Bearer #{bearer_token}"
        @app.call(env)
      end

      private

      def bearer_token
        @bearer_token ||= fetch_bearer_token
      end

      def fetch_bearer_token
        validate_credentials!

        response = Faraday.post(LOGIN_URL) do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = JSON.generate(apikey: api_token, pin: pin)
        end

        handle_login_response(response)
      end

      def validate_credentials!
        raise TVDB::ConfigurationError, 'TVDB API token is missing' if api_token.nil? || api_token.empty?
        raise TVDB::ConfigurationError, 'TVDB PIN is missing' if pin.nil? || pin.empty?
      end

      def handle_login_response(response)
        unless response.success?
          raise TVDB::AuthenticationError, "Failed to authenticate with TVDB API: #{response.body}"
        end

        JSON.parse(response.body).dig('data', 'token')
      end

      def api_token
        @api_token || ENV.fetch('TVDB_API_TOKEN', nil)
      end

      def pin
        @pin || ENV.fetch('TVDB_PIN', nil)
      end
    end
  end
end

Faraday::Request.register_middleware(tvdb_auth: TVDB::Middleware::Authentication)
