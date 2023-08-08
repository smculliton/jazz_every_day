require './lib/spotify_facade'
require './lib/openai_facade'
require './lib/twitter_client'

class PostGenerator
  attr_reader :artist, :twitter_keys

  def initialize(twitter_keys)
    @artist = SpotifyFacade.get_jazz_artist
    @twitter_keys = twitter_keys
  end

  def generate_post
    twitter = TwitterClient.new(twitter_keys)
    image = twitter.upload_media(artist.image_url)
    image_id = image[:media_id_string]

    text = OpenAiFacade.create_copy(artist.name)

    twitter.thread(text, image_id)
  end
end

