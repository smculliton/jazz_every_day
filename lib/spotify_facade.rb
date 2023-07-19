require './lib/spotify_service'
require './lib/artist'

class SpotifyFacade
  def self.get_jazz_artist
    search = SpotifyService.search_artists('genre:jazz')

    Artist.new(search[:artists][:items].first)
  end
end