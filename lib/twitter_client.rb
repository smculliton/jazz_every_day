require 'faraday'
require 'dotenv'
require 'base64'
require 'open-uri'
require './lib/twitter_auth.rb'
Dotenv.load

class TwitterClient
  def initialize(key_hash)
    @key_hash = key_hash
  end

  def post_tweet_w_media(text, media_id)
    body = { text: text, media: { media_ids: [media_id]} }.to_json
    conn.post('/2/tweets') do |req|
      req.headers['Authorization'] = TwitterAuth.new('POST', 'https://api.twitter.com/2/tweets', @key_hash).header_string
      req.body = body
    end
  end

  def post_tweet(text)
    body = { text: text }.to_json
    conn.post('/2/tweets') do |req|
      req.headers['Authorization'] = TwitterAuth.new('POST', 'https://api.twitter.com/2/tweets', @key_hash).header_string
      req.body = body
    end
  end

  def user
    conn.get('/2/users/me') do |req|
      req.headers['Authorization'] = TwitterAuth.new('GET', 'https://api.twitter.com/2/users/me', @key_hash, { expansions: 'pinned_tweet_id' }).header_string
      req.params = { expansions: 'pinned_tweet_id' }
    end
  end

  def upload_media(img_url)
    img = Base64.encode64( open(img_url).read).gsub("\n", '')
    body = { media_data: img }

    Faraday.post('https://upload.twitter.com/1.1/media/upload.json') do |req|
      req.headers['Authorization'] = TwitterAuth.new('POST', 'https://upload.twitter.com/1.1/media/upload.json', @key_hash, { media_data: img }).header_string
      req.body = body
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
x = client.post_tweet_w_media('Sick pic!', '1681451935298371584')
require 'pry'; binding.pry