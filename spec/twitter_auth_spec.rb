require 'rspec'
require './lib/twitter_auth'

RSpec.describe TwitterAuth do 
  before(:each) do 
    @key_hash = {
      consumer_key: 'xvz1evFS4wEEPTGEFPHBog',
      consumer_secret: 'c_secret',
      access_token: '370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb',
      access_secret: 'a_secret'
    }
    @method = 'POST'
    @base_uri = 'www.twitter.com'

    @oauth_nonce = 'kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg'
    @oauth_signature = 'tnnArxj06cWHq44gCs1OSKk/jLY='
    @oauth_timestamp = '1318622958'

    @auth = TwitterAuth.new(@method, @base_uri, @key_hash)
  end
  describe 'creation' do 
    it 'exists' do 
      expect(@auth).to be_a TwitterAuth
      expect(@auth.base_uri).to eq(@base_uri)
      expect(@auth.method).to eq(@method)
      expect(@auth.consumer_key).to eq(@key_hash[:consumer_key])
    end
  end

  describe 'header string' do
    it 'creates a string from given parameters' do
      allow(@auth).to receive(:oauth_nonce) { @oauth_nonce }
      allow(@auth).to receive(:oauth_signature) { @oauth_signature }
      allow(@auth).to receive(:oauth_timestamp) { @oauth_timestamp }

      expect(@auth.header_string).to eq('OAuth oauth_consumer_key="xvz1evFS4wEEPTGEFPHBog", oauth_nonce="kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg", oauth_signature="tnnArxj06cWHq44gCs1OSKk%2FjLY%3D", oauth_signature_method="HMAC-SHA1", oauth_timestamp="1318622958", oauth_token="370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb", oauth_version="1.0"')
    end
  end
end