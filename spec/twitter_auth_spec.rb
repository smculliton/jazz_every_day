require 'rspec'
require './lib/twitter_auth'

RSpec.describe TwitterAuth do 
  before(:each) do 
    @test_date = DateTime.new(2001,2,3,4,5,6)
    allow(DateTime).to receive(:now) { @test_date }
    @key_hash = {
      consumer_key: 'xvz1evFS4wEEPTGEFPHBog',
      consumer_secret: 'c_secret',
      access_token: '370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb',
      token_secret: 'a_secret'
    }
    @method = 'POST'
    @base_url = 'www.twitter.com'

    @oauth_nonce = 'kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg'
    @oauth_signature = 'tnnArxj06cWHq44gCs1OSKk/jLY='
    @oauth_timestamp = '1318622958'

    @auth = TwitterAuth.new(@method, @base_url, @key_hash)
  end
  describe 'creation' do 
    it 'exists' do 
      expect(@auth).to be_a TwitterAuth
      expect(@auth.base_url).to eq(@base_url)
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

    xit 'includes optional params if given' do
      auth = TwitterAuth.new(@method, @base_url, @key_hash, { text: 'Hello, World'})
      allow(auth).to receive(:oauth_nonce) { @oauth_nonce }
      allow(auth).to receive(:oauth_signature) { @oauth_signature }
      allow(auth).to receive(:oauth_timestamp) { @oauth_timestamp }
      
      expect(auth.header_string.include?('text="Hello%2C%20World"')).to eq(true)
    end
  end

  describe 'instance methods' do 
    describe '#oauth_timestamp' do 
      it 'returns a timestamp represented by seconds' do 
        expect(@auth.oauth_timestamp).to eq(@test_date.strftime('%s'))
      end
    end

    describe '#oauth_signature' do 
      it 'returns oauth signature based on provided info' do 
        expect(@auth.oauth_signature).to be_a String
      end
    end

    describe '#oauth_nonce' do 
      it 'generates a random string' do 
        expect(@auth.oauth_nonce).to be_a String
      end

      it 'the random generated string does not change' do 
        str = @auth.oauth_nonce
        expect(@auth.oauth_nonce).to eq(str)
      end
    end
  end
end