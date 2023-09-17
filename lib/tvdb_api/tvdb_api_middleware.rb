require 'faraday'
require 'json'

class TVDBAPIMiddleware < Faraday::Middleware
  URL = 'https://api4.thetvdb.com/v4/login'

  def call(env)
    env[:request_headers]['Authorization'] = "Bearer #{fetch_bearer_token}"

    @app.call(env)
  end

  def fetch_bearer_token
    api_token = ENV['TVDB_API_TOKEN']
    pin = ENV['TVDB_PIN']

    raise "TVDB_API_TOKEN environment variable is missing" if api_token.nil?
    raise "TVDB_PIN environment variable is missing" if pin.nil?

    return @bearer_token if @bearer_token

    response = Faraday.post(URL) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = JSON.generate({
        'apikey': api_token,
        'pin': pin
      })
    end

    raise "Failed to login: #{response.body}" unless response.success?

    @bearer_token = JSON.parse(response.body)['data']['token']
  end
end
