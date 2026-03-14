# frozen_string_literal: true

require 'webmock/rspec'
require_relative '../lib/tvdb_api'

RSpec.describe TVDB::Middleware::Authentication do
  let(:app) { ->(env) { env } }
  let(:login_url) { 'https://api4.thetvdb.com/v4/login' }

  before do
    allow(ENV).to receive(:fetch).and_call_original
  end

  describe 'with missing credentials' do
    it 'raises ConfigurationError when TVDB_API_TOKEN is missing' do
      allow(ENV).to receive(:fetch).with('TVDB_API_TOKEN', nil).and_return(nil)
      allow(ENV).to receive(:fetch).with('TVDB_PIN', nil).and_return('some_pin')

      middleware = described_class.new(app)
      env = { request_headers: {} }

      expect { middleware.call(env) }.to raise_error(TVDB::ConfigurationError, 'TVDB API token is missing')
    end

    it 'raises ConfigurationError when TVDB_PIN is missing' do
      allow(ENV).to receive(:fetch).with('TVDB_API_TOKEN', nil).and_return('some_token')
      allow(ENV).to receive(:fetch).with('TVDB_PIN', nil).and_return(nil)

      middleware = described_class.new(app)
      env = { request_headers: {} }

      expect { middleware.call(env) }.to raise_error(TVDB::ConfigurationError, 'TVDB PIN is missing')
    end
  end

  describe 'with valid credentials from environment' do
    before do
      allow(ENV).to receive(:fetch).with('TVDB_PIN', nil).and_return('some_pin')
      allow(ENV).to receive(:fetch).with('TVDB_API_TOKEN', nil).and_return('some_token')
      stub_request(:post, login_url)
        .to_return(body: '{"data": {"token": "fake_token"}}', status: 200)
    end

    it 'adds Authorization header with bearer token' do
      middleware = described_class.new(app)
      env = { request_headers: {} }

      middleware.call(env)

      expect(env[:request_headers]['Authorization']).to eq('Bearer fake_token')
    end

    it 'caches the bearer token across multiple calls' do
      middleware = described_class.new(app)

      middleware.call({ request_headers: {} })
      middleware.call({ request_headers: {} })
      middleware.call({ request_headers: {} })

      expect(WebMock).to have_requested(:post, login_url).once
    end
  end

  describe 'with explicit credentials' do
    before do
      stub_request(:post, login_url)
        .to_return(body: '{"data": {"token": "explicit_token"}}', status: 200)
    end

    it 'uses provided credentials instead of environment variables' do
      middleware = described_class.new(app, api_token: 'my_token', pin: 'my_pin')
      env = { request_headers: {} }

      middleware.call(env)

      expect(env[:request_headers]['Authorization']).to eq('Bearer explicit_token')
    end
  end

  describe 'when login fails' do
    before do
      allow(ENV).to receive(:fetch).with('TVDB_PIN', nil).and_return('some_pin')
      allow(ENV).to receive(:fetch).with('TVDB_API_TOKEN', nil).and_return('invalid_token')
      stub_request(:post, login_url)
        .to_return(body: '{"status": "failure", "message": "Invalid credentials"}', status: 401)
    end

    it 'raises AuthenticationError' do
      middleware = described_class.new(app)
      env = { request_headers: {} }

      expect { middleware.call(env) }.to raise_error(TVDB::AuthenticationError, /Failed to authenticate/)
    end
  end

  describe 'backwards compatibility' do
    it 'provides TVDBAPIMiddleware alias' do
      expect(TVDBAPIMiddleware).to eq(TVDB::Middleware::Authentication)
    end
  end
end
