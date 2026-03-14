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

  context 'when performing a typed search query' do
    it 'returns series results when searching by type' do
      stub_request(:get, "#{BASE_URL}/search?query=simpsons&type=series")
        .to_return(body: '{"data": [{"name": "The Simpsons", "type": "series"}]}', status: 200)

      response = api.search_by_type('simpsons', 'series')

      expect(response['data'].first['type']).to eq('series')
    end

    it 'returns movie results when searching by type' do
      stub_request(:get, "#{BASE_URL}/search?query=inception&type=movie")
        .to_return(body: '{"data": [{"name": "Inception", "type": "movie"}]}', status: 200)

      response = api.search_by_type('inception', 'movie')

      expect(response['data'].first['type']).to eq('movie')
    end
  end

  context 'when fetching a movie by ID' do
    it 'returns movie details with default params' do
      stub_request(:get, "#{BASE_URL}/movies/12879/extended?meta=translations&short=false")
        .to_return(body: '{"data": {"id": 12879, "name": "The Dark Knight"}}', status: 200)

      response = api.movie(12_879)

      expect(response['data']['id']).to eq(12_879)
      expect(response['data']['name']).to eq('The Dark Knight')
    end
  end

  context 'when fetching a series by ID' do
    it 'returns series details with default params' do
      stub_request(:get, "#{BASE_URL}/series/75299/extended?meta=translations&short=false")
        .to_return(body: '{"data": {"id": 75299, "name": "The Simpsons"}}', status: 200)

      response = api.series(75_299)

      expect(response['data']['id']).to eq(75_299)
      expect(response['data']['name']).to eq('The Simpsons')
    end
  end

  context 'when fetching a person by ID' do
    it 'returns person details' do
      stub_request(:get, "#{BASE_URL}/people/256583/extended")
        .to_return(body: '{"data": {"id": 256583, "name": "Martin Sheen"}}', status: 200)

      response = api.person(256_583)

      expect(response['data']['id']).to eq(256_583)
      expect(response['data']['name']).to eq('Martin Sheen')
    end
  end

  context 'when API returns an error' do
    it 'returns error response from search' do
      stub_request(:get, "#{BASE_URL}/search?query=nonexistent")
        .to_return(body: '{"status": "failure", "message": "Not found"}', status: 404)

      response = api.search('nonexistent')

      expect(response['status']).to eq('failure')
    end
  end
end
