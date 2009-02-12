module ApplicationHelper
  def limit_words_to(paragraph, number_of_words)
    words = paragraph.split(' ')
    if words.size <= number_of_words
      paragraph
    else
      words[0..number_of_words].join(" ") + "..."
    end
  end
end