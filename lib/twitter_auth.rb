require 'erb'
require 'securerandom'
require 'date'
require './lib/twitter_signature.rb'

class TwitterAuth
  attr_reader :consumer_key, :consumer_secret, :access_token, :token_secret, :method, :base_url, :oauth_nonce, :oauth_timestamp

  def initialize(method, base_url, key_hash)
    @method = method
    @base_url = base_url
    @consumer_key = key_hash[:consumer_key]
    @consumer_secret = key_hash[:consumer_secret]
    @access_token = key_hash[:access_token]
    @access_secret = key_hash[:token_secret]
    @oauth_nonce = generate_oauth_nonce
    @oauth_timestamp = generate_oauth_timestamp
  end

  def header_string
    param_hash.reduce('OAuth ') do |str, (key, value)|
      "#{str}#{ERB::Util.url_encode key}=\"#{ERB::Util.url_encode value}\", "
    end.chop.chop
  end

  def param_hash
    {
      oauth_consumer_key: consumer_key,
      oauth_nonce: oauth_nonce,
      oauth_signature: oauth_signature,
      oauth_signature_method: 'HMAC-SHA1',
      oauth_timestamp: oauth_timestamp,
      oauth_token: access_token,
      oauth_version: '1.0'
    }
  end

  def generate_oauth_timestamp
    DateTime.now.strftime('%s')
  end

  def oauth_signature
    TwitterSignature.new(signature_param_hash, signature_key_hash, method, base_url).signature
  end

  def signature_param_hash
    {
      oauth_consumer_key: consumer_key,
      oauth_nonce: oauth_nonce,
      oauth_signature_method: 'HMAC-SHA1',
      oauth_timestamp: oauth_timestamp,
      oauth_token: access_token,
      oauth_version: '1.0'
    }
  end

  def signature_key_hash
    {
      consumer_secret: consumer_secret,
      token_secret: token_secret
    }
  end

  def generate_oauth_nonce
    SecureRandom.hex(13)
  end
end