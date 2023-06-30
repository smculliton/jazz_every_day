require 'faraday'
require 'dotenv'
require './lib/twitter_auth.rb'
Dotenv.load

class TwitterClient
  def initialize(key_hash)
    @key_hash = key_hash
  end

  def post_tweet(text)
    body = { text: text }.to_json
    conn.post('/2/tweets') do |req|
      req.headers['Authorization'] = TwitterAuth.new('POST', 'https://api.twitter.com/2/tweets', @key_hash).header_string
      req.headers['Content-Length'] = body.length.to_s
      req.body = body
    end
  end

  def user
    conn.get('/2/users/me') do |req|
      req.headers['Authorization'] = TwitterAuth.new('GET', 'https://api.twitter.com/2/users/me', @key_hash, { expansions: 'pinned_tweet_id' }).header_string
      req.params = { expansions: 'pinned_tweet_id' }
    end
  end

  def conn
    Faraday.new({url: 'https://api.twitter.com', headers: {'Content-Type' => 'application/json'}})
  end
end

key_hash = {
  consumer_key: ENV["consumer_key"],
  consumer_secret: ENV["consumer_secret"],
  access_token: ENV["access_token"],
  token_secret: ENV["token_secret"]
}

client = TwitterClient.new(key_hash)

require 'pry'; binding.pry