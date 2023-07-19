require 'rspec'
require './lib/artist'

RSpec.describe Artist do 
  let(:artist_data) {
    {
      :external_urls=>{:spotify=>"https://open.spotify.com/artist/4QQgXkCYTt3BlENzhyNETg"},
      :followers=>{:href=>nil, :total=>3956928},
      :genres=>["disco", "funk", "jazz funk", "soul"],
      :href=>"https://api.spotify.com/v1/artists/4QQgXkCYTt3BlENzhyNETg",
      :id=>"4QQgXkCYTt3BlENzhyNETg",
      :images=>
        [
          {:height=>640, :url=>"https://i.scdn.co/image/ab6761610000e5eb9722e16a886767adf1178f92", :width=>640},
          {:height=>320, :url=>"https://i.scdn.co/image/ab676161000051749722e16a886767adf1178f92", :width=>320},
          {:height=>160, :url=>"https://i.scdn.co/image/ab6761610000f1789722e16a886767adf1178f92", :width=>160}
        ],
      :name=>"Earth, Wind & Fire",
      :popularity=>71,
      :type=>"artist",
      :uri=>"spotify:artist:4QQgXkCYTt3BlENzhyNETg"
    }
  }

  describe '#initialize' do 
    it 'has a name and image url' do 
      artist = Artist.new(artist_data)

      expect(artist.name).to eq("Earth, Wind & Fire")
      expect(artist.image_url).to eq("https://i.scdn.co/image/ab6761610000e5eb9722e16a886767adf1178f92")
    end
  end
end
