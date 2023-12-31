require 'faraday'
require 'dotenv'
require 'base64'
require 'open-uri'
require './lib/twitter_auth'
require './lib/thread_formatter'
Dotenv.load

class TwitterClient
  include ThreadFormatter

  def initialize(key_hash)
    @key_hash = key_hash
  end

  def post_tweet_w_media(text, media_id)
    body = { text: text, media: { media_ids: [media_id] } }.to_json
    conn.post('/2/tweets') do |req|
      req.headers['Authorization'] =
        TwitterAuth.new('POST', 'https://api.twitter.com/2/tweets', @key_hash).header_string
      req.body = body
    end
  end

  def post_tweet(text)
    body = { text: text }.to_json
    conn.post('/2/tweets') do |req|
      req.headers['Authorization'] =
        TwitterAuth.new('POST', 'https://api.twitter.com/2/tweets', @key_hash).header_string
      req.body = body
    end
  end

  def reply_tweet(text, tweet_id)
    body = { text: text, reply: { in_reply_to_tweet_id: tweet_id } }.to_json
    conn.post('/2/tweets') do |req|
      req.headers['Authorization'] =
        TwitterAuth.new('POST', 'https://api.twitter.com/2/tweets', @key_hash).header_string
      req.body = body
    end
  end

  def thread(text, media_id = false)
    text_array = reformat_text_to_thread(text)

    tweet = if media_id
              post_tweet_w_media(text_array[0].concat(' 🧵'), media_id)
            else
              post_tweet(text_array[0].concat(' 🧵'))
            end

    id = JSON.parse(tweet.body, symbolize_names: true)[:data][:id]
    text_array[1..-1].each do |reply_text|
      reply_tweet = reply_tweet(reply_text, id)

      id = JSON.parse(reply_tweet.body, symbolize_names: true)[:data][:id]
    end
    tweet
  end

  def delete_tweet(id)
    uri = "/2/tweets/#{id}"
    conn.delete(uri) do |req|
      req.headers['Authorization'] = TwitterAuth.new('DELETE', "https://api.twitter.com#{uri}", @key_hash).header_string
    end
  end

  def user
    conn.get('/2/users/me') do |req|
      req.headers['Authorization'] =
        TwitterAuth.new('GET', 'https://api.twitter.com/2/users/me', @key_hash,
                        { expansions: 'pinned_tweet_id' }).header_string
      req.params = { expansions: 'pinned_tweet_id' }
    end
  end

  def upload_media(img_url)
    img = Base64.encode64(URI.open(img_url).read).gsub("\n", '')
    body = { media_data: img }

    res = Faraday.post('https://upload.twitter.com/1.1/media/upload.json') do |req|
      req.headers['Authorization'] =
        TwitterAuth.new('POST', 'https://upload.twitter.com/1.1/media/upload.json', @key_hash,
                        { media_data: img }).header_string
      req.body = body
    end

    JSON.parse(res.body, symbolize_names: true)
  end

  def conn
    Faraday.new({ url: 'https://api.twitter.com', headers: { 'Content-Type' => 'application/json' } })
  end
end
