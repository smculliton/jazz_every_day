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

post = "Antônio Carlos Jobim, better known as Tom Jobim, was a Brazilian composer and musician whose contributions to the world of music had a lasting impact. Born on January 25, 1927, in Rio de Janeiro, Jobim's love for music bloomed at an early age. His father was a diplomat, which allowed Jobim to experience various cultures and musical styles during his travels.\n\nDuring the 1950s, Jobim began his career as a pianist and arranger, playing in bars and clubs around Rio de Janeiro. It was during one of these performances that he met influential Brazilian poet and diplomat Vinicius de Moraes. They formed a strong creative partnership, and together they wrote some of the most iconic bossa nova songs of all time.\n\nOne particular song, \"Garota de Ipanema\" (The Girl from Ipanema), became an international sensation. Sung by Jobim's friend, João Gilberto, and his wife, Astrud Gilberto, the song captured the essence of the bossa nova movement and the beauty of Brazilian women. It skyrocketed to success and introduced bossa nova to the world.\n\nJobim, however, did not stop at just composing and performing. He pushed musical boundaries, blending traditional Brazilian rhythms with jazz and other global influences. His penchant for melodies and rich harmonies made his compositions stand out, earning him the title of the \"Gershwin of Brazil.\"\n\nAs his international recognition grew, Jobim collaborated with renowned musicians like Frank Sinatra and Ella Fitzgerald, showcasing his versatility and talent. His music fused Brazilian sounds with American jazz, creating a unique and enchanting style that appealed to a wider audience.\n\nThroughout his career, Jobim composed numerous timeless classics, including \"Desafinado,\" \"Corcovado,\" and \"Wave.\" His melodies painted vibrant images of the coastlines, forests, and rhythms of Brazil, evoking a sense of nostalgia and longing.\n\nAntônio Carlos Jobim's music transcended borders, capturing the hearts of people worldwide. His contributions to the bossa nova genre and his iconic compositions will forever be remembered, solidifying his legacy as one of Brazil's greatest composers and an influential figure in music history."