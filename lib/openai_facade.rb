require './lib/openai_service'

class OpenAiFacade
  def self.create_copy(name)
    data = OpenAiService.get_story(name)

    data[:choices][0][:message][:content]
  end
end