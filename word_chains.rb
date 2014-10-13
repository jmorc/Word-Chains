class WordChainer
  attr_accessor :dictionary, :current_words, :all_seen_words
  
  def initialize(dictionary_file_name)
    @dictionary = File.readlines(dictionary_file_name)
    @dictionary.each do |line|
      line.chomp!
    end
    @current_words = []
    @all_seen_words = []
  end
  
  def adjacent_words(word)
    one_ltr_off = []
    @dictionary.each do |dict_word|
      if one_letter_difference?(word, dict_word) 
        one_ltr_off << dict_word
      end 
    end
      one_ltr_off
    end
  
  def one_letter_difference?(word1, word2)
    return false if word1.length != word2.length
    diff_ltr_count = 0
    word2_arr = word2.split('')
    word1.split('').each_with_index do |ltr, idx|
      if ltr != word2_arr[idx] 
        diff_ltr_count += 1
      end
    end
    diff_ltr_count == 1 ? true : false
  end
  
  def run(source, target)
    @current_words << source
    @all_seen_words << source
    until @current_words.empty?
      new_current_words = []
      @current_words.each do |word|
        new_current_words = explore_current_words(word, new_current_words)
      end
      p new_current_words
      @current_words = new_current_words
    end
  end
  
  def explore_current_words(word, new_current_words)
    adjacents = adjacent_words(word)
    adjacents.each do |adjacent_wrd|
      next if @all_seen_words.include?(adjacent_wrd) 
      @all_seen_words << adjacent_wrd
      new_current_words << adjacent_wrd
    end
    new_current_words
  end
end

word_chainer = WordChainer.new('dict.txt')
# p word_chainer.dictionary.include?('blimp')
# p word_chainer.one_letter_difference?('foo','fbb')
p word_chainer.run('block', 'block')