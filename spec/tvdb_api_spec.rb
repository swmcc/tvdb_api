# frozen_string_literal: true

require 'webmock/rspec'
require_relative '../lib/tvdb_api'

RSpec.describe TVDB::Client do
  let(:base_url) { 'https://api4.thetvdb.com/v4' }
  let(:tvdb_pin) { 'some_pin' }
  let(:tvdb_api_token) { 'some_token' }

  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with('TVDB_PIN', nil).and_return(tvdb_pin)
    allow(ENV).to receive(:fetch).with('TVDB_API_TOKEN', nil).and_return(tvdb_api_token)
    stub_request(:post, "#{base_url}/login")
      .to_return(body: '{"data": {"token": "fake_token"}}', status: 200)
  end

  let(:client) { described_class.new }

  describe '#initialize' do
    it 'sets up a Faraday connection' do
      expect(client.send(:connection)).to be_instance_of(Faraday::Connection)
    end

    it 'accepts explicit credentials' do
      client_with_creds = described_class.new(api_token: 'explicit_token', pin: 'explicit_pin')
      expect(client_with_creds.send(:api_token)).to eq('explicit_token')
      expect(client_with_creds.send(:pin)).to eq('explicit_pin')
    end
  end

  describe '#search' do
    it 'returns search results' do
      stub_request(:get, "#{base_url}/search?query=batman")
        .to_return(body: '{"data": {"results": ["Batman"]}}', status: 200)

      response = client.search('batman')

      expect(response['data']['results']).to eq(['Batman'])
    end
  end

  describe '#search_by_type' do
    it 'returns series results when searching by type' do
      stub_request(:get, "#{base_url}/search?query=simpsons&type=series")
        .to_return(body: '{"data": [{"name": "The Simpsons", "type": "series"}]}', status: 200)

      response = client.search_by_type('simpsons', 'series')

      expect(response['data'].first['type']).to eq('series')
    end

    it 'returns movie results when searching by type' do
      stub_request(:get, "#{base_url}/search?query=inception&type=movie")
        .to_return(body: '{"data": [{"name": "Inception", "type": "movie"}]}', status: 200)

      response = client.search_by_type('inception', 'movie')

      expect(response['data'].first['type']).to eq('movie')
    end
  end

  describe '#movie' do
    it 'returns movie details with default params' do
      stub_request(:get, "#{base_url}/movies/12879/extended?meta=translations&short=false")
        .to_return(body: '{"data": {"id": 12879, "name": "The Dark Knight"}}', status: 200)

      response = client.movie(12_879)

      expect(response['data']['id']).to eq(12_879)
      expect(response['data']['name']).to eq('The Dark Knight')
    end
  end

  describe '#series' do
    it 'returns series details with default params' do
      stub_request(:get, "#{base_url}/series/75299/extended?meta=translations&short=false")
        .to_return(body: '{"data": {"id": 75299, "name": "The Simpsons"}}', status: 200)

      response = client.series(75_299)

      expect(response['data']['id']).to eq(75_299)
      expect(response['data']['name']).to eq('The Simpsons')
    end
  end

  describe '#person' do
    it 'returns person details' do
      stub_request(:get, "#{base_url}/people/256583/extended")
        .to_return(body: '{"data": {"id": 256583, "name": "Martin Sheen"}}', status: 200)

      response = client.person(256_583)

      expect(response['data']['id']).to eq(256_583)
      expect(response['data']['name']).to eq('Martin Sheen')
    end
  end

  describe 'error handling' do
    it 'raises APIError on failed requests' do
      stub_request(:get, "#{base_url}/search?query=nonexistent")
        .to_return(body: '{"status": "failure", "message": "Not found"}', status: 404)

      expect { client.search('nonexistent') }.to raise_error(TVDB::APIError, 'Not found')
    end

    it 'raises ArgumentError for unknown endpoints' do
      expect { client.send(:get, :unknown) }.to raise_error(ArgumentError, 'Unknown endpoint: unknown')
    end
  end

  describe 'backwards compatibility' do
    it 'provides TVDBApi alias' do
      expect(TVDBApi).to eq(TVDB::Client)
    end
  end
end
