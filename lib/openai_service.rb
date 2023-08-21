require 'faraday'
require 'dotenv'
Dotenv.load

class OpenAiService
  def self.get_story(name)
    response = conn.post('/v1/chat/completions') do |req|
      req.body = body(name)
    end

    JSON.parse(response.body, symbolize_names: true)
  end

  def self.body(name)
    {
      'model': 'gpt-3.5-turbo',
      'messages': [
        {
          'role': 'system',
          'content': 'You are teaching a music history class'
        },
        {
          'role': 'user',
          'content': "In 300 words, tell a story about #{name}"
        }
      ]
    }.to_json
  end

  def self.conn
    Faraday.new({ url: 'https://api.openai.com',
                  headers: { 'Authorization' => "Bearer #{ENV['openai_key']}", 'Content-Type' => 'application/json' } })
  end
end
