require 'rspec'
require './lib/twitter_client'

RSpec.describe TwitterClient do 
  let(:key_hash) {{
    consumer_key: ENV["consumer_key"],
    consumer_secret: ENV["consumer_secret"],
    access_token: ENV["access_token"],
    token_secret: ENV["token_secret"]
  }}

  xit 'can reply to tweets' do 
    client = TwitterClient.new(key_hash)
    tweet_id = '1686514017798668290'

    client.reply_tweet('hi', tweet_id)
  end

  xit 'can delete tweets' do 
    client = TwitterClient.new(key_hash)
    tweet = client.post_tweet('hey there')
    
    id = JSON.parse(tweet.body, symbolize_names: true)[:data][:id]
    
    delete = client.delete_tweet(id)
    data = JSON.parse(delete.body, symbolize_names: true)
    
    expect(data[:data][:deleted]).to eq(true)
  end
end