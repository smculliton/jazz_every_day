require 'rspec'
require './lib/openai_facade'

RSpec.describe OpenAiFacade do 
  describe '#create_copy' do 
    it 'creates the copy for a post' do 
      copy = OpenAiFacade.create_copy('Duke Ellington')

      expect(copy).to be_a String
    end
  end
end