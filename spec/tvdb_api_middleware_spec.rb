# frozen_string_literal: true

require 'webmock/rspec'
require_relative '../lib/tvdb_api/tvdb_api_middleware'

describe TVDBAPIMiddleware do
  let(:env) { { request_headers: {} } }
  let(:app) { double('app') }
  let(:middleware) { described_class.new(app) }

  before do
    allow(app).to receive(:call)
    allow(ENV).to receive(:[]).and_call_original
  end

  context 'when environment variables are missing' do
    it 'raises an error if TVDB_API_TOKEN is missing' do
      allow(ENV).to receive(:[]).with('TVDB_PIN').and_return('some_pin')

      expect do
        middleware.call(env)
      end.to raise_error('TVDB_API_TOKEN environment variable is missing')
    end

    it 'raises an error if TVDB_PIN is missing' do
      allow(ENV).to receive(:[]).with('TVDB_API_TOKEN').and_return('some_token')

      expect do
        middleware.call(env)
      end.to raise_error('TVDB_PIN environment variable is missing')
    end
  end

  context 'when environment variables are present' do
    before do
      allow(ENV).to receive(:[]).with('TVDB_PIN').and_return('some_pin')
      allow(ENV).to receive(:[]).with('TVDB_API_TOKEN').and_return('some_token')
      stub_request(:post, 'https://api4.thetvdb.com/v4/login').to_return(body: '{"data": {"token": "fake_token"}}',
                                                                         status: 200)
    end

    it 'adds Authorization header if bearer token is present' do
      middleware = TVDBAPIMiddleware.new(->(env) { env })
      env = { request_headers: {} }

      middleware.call(env)

      expect(env[:request_headers]['Authorization']).to eq('Bearer fake_token')
    end
  end
end
