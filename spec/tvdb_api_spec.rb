# frozen_string_literal: true

require 'webmock/rspec'
require_relative '../lib/tvdb_api'

describe TVDBApi do
  BASE_URL = 'https://api4.thetvdb.com/v4'
  let(:tvdb_pin) { 'some_pin' }
  let(:tvdb_api_token) { 'some_token' }

  before(:each) do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('TVDB_PIN').and_return(tvdb_pin)
    allow(ENV).to receive(:[]).with('TVDB_API_TOKEN').and_return(tvdb_api_token)
    stub_request(:post, "#{BASE_URL}/login").to_return(body: '{"data": {"token": "fake_token"}}', status: 200)
  end

  let(:api) { TVDBApi.new }

  context 'when initialized' do
    it 'sets up a Faraday connection' do
      expect(api.instance_variable_get(:@conn)).to be_instance_of(Faraday::Connection)
    end
  end

  context 'when performing a search query' do
    it 'returns the expected data' do
      stub_request(:get, "#{BASE_URL}/search?query=batman")
        .to_return(body: '{"data": {"results": ["Batman"]}}', status: 200)

      json = JSON.dump(api.search('batman'))

      parsed_response = JSON.parse(json)
      expect(parsed_response['data']['results']).to eq(['Batman'])
    end
  end
end
