require './lib/spotify_service'
require './lib/artist'

class SpotifyFacade
  def self.get_jazz_artist
    search = SpotifyService.search_artists("genre:jazz year:#{decade}")

    Artist.new(search[:artists][:items].sample)
  end

  def self.decade
    %w[
      1920-1930
      1930-1940
      1940-1950
      1950-1960
      1960-1970
      1970-1980
      1980-1990
      1990-2000
      2000-2010
      2010-2020
    ].sample
  end
end
