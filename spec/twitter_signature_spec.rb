require 'rspec'
require './lib/twitter_signature'

RSpec.describe TwitterSignature do
  describe '#create_signature' do
    before(:each) do
      params = {
        include_entities: 'true',
        oauth_consumer_key: 'xvz1evFS4wEEPTGEFPHBog',
        oauth_nonce: 'kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg',
        oauth_signature_method: 'HMAC-SHA1',
        oauth_timestamp: '1318622958',
        oauth_token: '370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb',
        oauth_version: '1.0',
        status: 'Hello Ladies + Gentlemen, a signed OAuth request!'
      }
      @keys = {
        consumer_secret: 'kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw',
        token_secret: 'LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE'
      }
      @method = 'POST'
      @base_url = 'https://api.twitter.com/1.1/statuses/update.json'
      @signature = TwitterSignature.new(params, @keys, @method, @base_url)
    end

    describe '#param_string' do
      it 'creates parameter string' do
        expect(@signature.param_string).to eq('include_entities=true&oauth_consumer_key=xvz1evFS4wEEPTGEFPHBog&oauth_nonce=kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1318622958&oauth_token=370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb&oauth_version=1.0&status=Hello%20Ladies%20%2B%20Gentlemen%2C%20a%20signed%20OAuth%20request%21')
      end

      it 'sorts params alphabetically by key before generating string' do
        params = {
          status: 'Hello Ladies + Gentlemen, a signed OAuth request!',
          oauth_consumer_key: 'xvz1evFS4wEEPTGEFPHBog',
          oauth_signature_method: 'HMAC-SHA1',
          oauth_timestamp: '1318622958',
          include_entities: 'true',
          oauth_token: '370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb',
          oauth_version: '1.0',
          oauth_nonce: 'kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg'
        }
        signature = TwitterSignature.new(params, @keys, @method, @base_url)

        expect(signature.param_string).to eq('include_entities=true&oauth_consumer_key=xvz1evFS4wEEPTGEFPHBog&oauth_nonce=kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1318622958&oauth_token=370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb&oauth_version=1.0&status=Hello%20Ladies%20%2B%20Gentlemen%2C%20a%20signed%20OAuth%20request%21')
      end
    end

    it 'creates signature base string' do
      expect(@signature.base_string).to eq('POST&https%3A%2F%2Fapi.twitter.com%2F1.1%2Fstatuses%2Fupdate.json&include_entities%3Dtrue%26oauth_consumer_key%3Dxvz1evFS4wEEPTGEFPHBog%26oauth_nonce%3DkYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1318622958%26oauth_token%3D370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb%26oauth_version%3D1.0%26status%3DHello%2520Ladies%2520%252B%2520Gentlemen%252C%2520a%2520signed%2520OAuth%2520request%2521')
    end

    it 'creates signing key' do
      expect(@signature.signing_key).to eq('kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw&LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE')
    end

    it 'calculates signature' do
      expect(@signature.signature).to eq('hCtSmYh+iHYCEqBWrE7C7hYmtUk=')
    end
  end
end
