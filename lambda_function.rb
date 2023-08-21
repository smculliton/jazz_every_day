require './lib/post_generator'

def lambda_handler(event:, context:)
  twitter_keys = {
    consumer_key: ENV['consumer_key'],
    consumer_secret: ENV['consumer_secret'],
    access_token: ENV['access_token'],
    token_secret: ENV['token_secret']
  }

  pg = PostGenerator.new(twitter_keys)
  pg.generate_post
end
