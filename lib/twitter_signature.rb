require 'base64'
require 'openssl'
require 'erb'

class TwitterSignature
  def initialize(params, keys, method, base_url)
    @params = params
    @keys = keys
    @method = method
    @base_url = base_url
  end

  def param_string
    # Sort params alphabetically
    @params = @params.sort.to_h

    # Reduce params to param string
    @params.reduce('') do |str, (key, value)|
      "#{str}#{ERB::Util.url_encode key}=#{ERB::Util.url_encode value}&"
    end.chop
  end

  def base_string
    "#{@method}&#{ERB::Util.url_encode(@base_url)}&#{ERB::Util.url_encode param_string}"
  end

  def signing_key
    "#{ERB::Util.url_encode(@keys[:consumer_secret])}&#{ERB::Util.url_encode(@keys[:token_secret])}"
  end

  def signature
    Base64.encode64("#{OpenSSL::HMAC.digest('sha1', signing_key, base_string)}").chomp
  end
end
