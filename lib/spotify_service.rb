require 'base64'
require 'faraday'
require 'dotenv'
require 'uri'
Dotenv.load

class SpotifyService
  def self.search_artists(q)
    response = conn.get('/v1/search') do |req|
      req.params['q'] = q
      req.params['type'] = 'artist'
    end

    JSON.parse(response.body, symbolize_names: true)
  end

  def self.conn
    Faraday.new({
                  url: 'https://api.spotify.com',
                  headers: {
                    'Authorization' => "Bearer #{access_token}",
                    'Content-Type' => 'application/json'
                  }
                })
  end

  def self.access_token
    response = Faraday.post('https://accounts.spotify.com/api/token') do |req|
      req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
      req.headers['Authorization'] = "Basic #{client_credentials}"
      req.body = URI.encode_www_form({ grant_type: 'client_credentials' })
    end
    JSON.parse(response.body)['access_token']
  end

  def self.client_credentials
    Base64.encode64("#{ENV['spotify_client_id']}:#{ENV['spotify_client_secret']}")
          .delete("\n")
  end
end
