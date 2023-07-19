class Artist
  attr_reader :name, :image_url

  def initialize(data)
    @name = data[:name]
    @image_url = data[:images].first[:url]
  end
end
