class Tokenizer
  def do data, gram: 1
    words = if data.respond_to? :each
              data.map { |e| split_string(e)}.flatten
            else
              split_string(data)
            end
    if gram.respond_to? :each
      gram.map { |e| token_for_gramsize(words, e) }.flatten
    else
      token_for_gramsize(words, gram)
    end
  end

  private
  # TODO: decide on which of the two lines to use
  # scan is faster in MRI and RBX
  # split+reject is faster in JRuby(which itself is way faster than MRI and RBX)
  def split_string s
    s.scan(/\w+/)
    # s.split(/\W/).reject(&:empty?)
  end
  def token_for_gramsize words, size
    return words if size == 1

    words.each_cons(size).map { |e| e.join(" ") }
  end
end
