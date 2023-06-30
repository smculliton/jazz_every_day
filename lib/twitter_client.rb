require 'faraday'
require './lib/twitter_auth.rb'

class TwitterClient
  def initialize(key_hash)
    @key_hash = key_hash
  end

  def post_tweet(text)
    response = conn.post('/2/tweets') do |req|
      req.headers['Authorization'] = TwitterAuth.new('POST', 'https://api.twitter.com/2/tweets', @key_hash, { text: text }).header_string
      req.body = { text: text }.to_json
    end
  end

  def user
    response = conn.get('/2/users/me') do |req|
      req.headers['Authorization'] = TwitterAuth.new('GET', 'https://api.twitter.com/2/users/me', @key_hash, { expansions: 'pinned_tweet_id' }).header_string
      req.params = { expansions: 'pinned_tweet_id' }
    end
  end

  def conn
    Faraday.new({url: 'https://api.twitter.com', headers: {'Content-Type' => 'application/json'}})
  end
end

key_hash = {
  consumer_key: 'nSCjmUsC9qiOEPwTBaNaVaMwQ',
  consumer_secret: '2BL2xnVx4NREA3JNd007RBOjIPUd2t72s29wy0GzD9s5uwtrg1',
  access_token: '1673555169144094720-f817s5OLWDg4p6Cs6NA9CTQGQaGRCV',
  token_secret: '2VQylPqQehzbl7akgLTomLpgVZwQ0xKWOqDXTnu3YiwMP'
}

client = TwitterClient.new(key_hash)

require 'pry'; binding.pry