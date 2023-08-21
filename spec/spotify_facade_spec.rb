require 'rspec'
require './lib/spotify_facade'

RSpec.describe SpotifyFacade do
  describe '#get_jazz_artist' do
    it 'returns an artist name' do
      expect(SpotifyFacade.get_jazz_artist).to be_a Artist
    end
  end
end
