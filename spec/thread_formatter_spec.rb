require 'rspec'
require './lib/twitter_client'

RSpec.describe ThreadFormatter do
  describe '#reformat_text_to_thread' do
    let(:client) { TwitterClient.new({}) }

    it 'returns single element array if text is under 280 characters' do
      thread = client.reformat_text_to_thread('hello')

      expect(thread).to be_a Array
      expect(thread.length).to eq(1)
      expect(thread[0]).to eq('hello')
    end

    it 'strips new lines if under 280 characters' do
      thread = client.reformat_text_to_thread("hello\n\n")

      expect(thread).to be_a Array
      expect(thread.length).to eq(1)
      expect(thread[0]).to eq('hello')
    end

    it 'if text is greater than 280 characters it splits it into two complete sentences' do
      text = "Antônio Carlos Jobim, better known as Tom Jobim, was a Brazilian composer and musician whose contributions to the world of music had a lasting impact. Born on January 25, 1927, in Rio de Janeiro, Jobim's love for music bloomed at an early age. His father was a diplomat, which allowed Jobim to experience various cultures and musical styles during his travels."

      thread = client.reformat_text_to_thread(text)

      expect(thread).to be_a Array
      expect(thread.length).to eq(2)
      expect(thread[0][-1]).to eq('.')
      expect(thread[1][-1]).to eq('.')
    end

    it 'adds end quotations if they exist after period' do
      text = 'Jobim, however, did not stop at just composing and performing. He pushed musical boundaries, blending traditional Brazilian rhythms with jazz and other global influences. His penchant for melodies and rich harmonies made his compositions stand out, earning him the title of the "Gershwin of Brazil."'

      thread = client.reformat_text_to_thread(text)

      expect(thread).to be_a Array
      expect(thread.length).to eq(2)
      expect(thread[0][-1]).to eq('.')
      expect(thread[1][-1]).to eq('"')
    end

    it 'formats a large paragraph' do
      text = "Antônio Carlos Jobim, better known as Tom Jobim, was a Brazilian composer and musician whose contributions to the world of music had a lasting impact. Born on January 25, 1927, in Rio de Janeiro, Jobim's love for music bloomed at an early age. His father was a diplomat, which allowed Jobim to experience various cultures and musical styles during his travels.\n\nDuring the 1950s, Jobim began his career as a pianist and arranger, playing in bars and clubs around Rio de Janeiro. It was during one of these performances that he met influential Brazilian poet and diplomat Vinicius de Moraes. They formed a strong creative partnership, and together they wrote some of the most iconic bossa nova songs of all time.\n\nOne particular song, \"Garota de Ipanema\" (The Girl from Ipanema), became an international sensation. Sung by Jobim's friend, João Gilberto, and his wife, Astrud Gilberto, the song captured the essence of the bossa nova movement and the beauty of Brazilian women. It skyrocketed to success and introduced bossa nova to the world.\n\nJobim, however, did not stop at just composing and performing. He pushed musical boundaries, blending traditional Brazilian rhythms with jazz and other global influences. His penchant for melodies and rich harmonies made his compositions stand out, earning him the title of the \"Gershwin of Brazil.\"\n\nAs his international recognition grew, Jobim collaborated with renowned musicians like Frank Sinatra and Ella Fitzgerald, showcasing his versatility and talent. His music fused Brazilian sounds with American jazz, creating a unique and enchanting style that appealed to a wider audience.\n\nThroughout his career, Jobim composed numerous timeless classics, including \"Desafinado,\" \"Corcovado,\" and \"Wave.\" His melodies painted vibrant images of the coastlines, forests, and rhythms of Brazil, evoking a sense of nostalgia and longing.\n\nAntônio Carlos Jobim's music transcended borders, capturing the hearts of people worldwide. His contributions to the bossa nova genre and his iconic compositions will forever be remembered, solidifying his legacy as one of Brazil's greatest composers and an influential figure in music history."
      thread = client.reformat_text_to_thread(text)

      expect(thread.all? { |e| e[0] != '"' }).to eq(true)
      expect(thread.all? { |e| e[-1] == '.' || e[-1] == '"' }).to eq(true)
      expect(thread.all? { |e| e.length <= 275 }).to eq(true)
    end

    it 'works with other examples' do
      text = "Ella Fitzgerald, the iconic jazz singer, emerged from a challenging upbringing to become a true musical legend. Born in 1917 in Newport News, Virginia, Ella faced adversity early on, as her parents separated when she was young. Struggling financially, she ended up in the care of her aunt, who soon passed away. By her early teens, Ella had experienced the pain of loss and poverty, often finding solace in music. In 1934, at the age of 17, Ella participated in an amateur contest at the Apollo Theater in Harlem. She had planned to dance, but stage fright led her to sing instead. She chose a song she knew well, \"Judy,\" and her soulful voice captured the audience's attention. She won first prize and began performing in local clubs, ultimately catching the eye of bandleader Chick Webb. Ella's partnership with Chick Webb's orchestra marked the beginning of her rise to fame. Despite her shy demeanor offstage, she exuded confidence and charisma in her performances. In 1938, her rendition of \"A-Tisket, A-Tasket\" skyrocketed her to national recognition and led to her becoming the band's vocalist. After Webb's passing in 1939, Ella took over leadership of the orchestra and continued to forge her unique path. She embarked on a solo career, mastering scat singing and using her voice as an instrument. Her collaborations with jazz luminaries like Duke Ellington and Louis Armstrong further solidified her status as a jazz icon. Ella's influence extended beyond music. In a racially segregated era, she faced discrimination firsthand, but she chose to combat it with her art. She performed for integrated audiences and broke down barriers through her sheer talent and grace. Ella Fitzgerald's legacy endures through her countless recordings and live performances, showcasing her unparalleled vocal range and emotional depth. Her journey from a challenging upbringing to becoming the \"First Lady of Song\" serves as a testament to the power of music to transcend adversity and touch the hearts of millions. Her voice, still celebrated today, remains a symbol of hope, resilience, and the transformative nature of art."

      thread = client.reformat_text_to_thread(text)

      expect(thread.all? { |e| e[0] != '"' }).to eq(true)
      expect(thread.all? { |e| e[-1] == '.' || e[-1] == '"' }).to eq(true)
      expect(thread.all? { |e| e.length <= 275 }).to eq(true)
    end
  end
end
