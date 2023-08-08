module ThreadFormatter
  def reformat_text_to_thread(text, thread_array = [])
    text.gsub!("\n", ' ') if thread_array.length == 0
    string = ''
    i = 0

    if text.length > 275
      loop do
        i += text.index('.')
        break if i > 275

        string.concat(text[0..text.index('.')])
        text = text[text.index('.') + 1..]
      end
    else 
      thread_array << text 
      return thread_array
    end

    # checks if there is a leftover end quotation after the last period
    if text[0] == '"'
      string.concat('"')
      text = text[1..]
    end

    thread_array << string
    reformat_text_to_thread(text.strip, thread_array)
  end
end



