require 'erb'
require 'securerandom'

class TwitterAuth
  attr_reader :consumer_key, :consumer_secret, :access_token, :access_secret, :method, :base_uri

  def initialize(method, base_uri, key_hash)
    @method = method
    @base_uri = base_uri
    @consumer_key = key_hash[:consumer_key]
    @consumer_secret = key_hash[:consumer_secret]
    @access_token = key_hash[:access_token]
    @access_secret = key_hash[:access_secret]
  end

  def header_string
    param_string.reduce('OAuth ') do |str, (key, value)|
      "#{str}#{ERB::Util.url_encode key}=\"#{ERB::Util.url_encode value}\", "
    end.chop.chop
  end

  def param_string
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

  def oauth_timestamp
  end

  def oauth_signature
  end

  def oauth_nonce
  end
end