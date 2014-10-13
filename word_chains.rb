class WordChainer
  attr_accessor :dictionary, :current_words, :all_seen_words
  
  def initialize(dictionary_file_name)
    @dictionary = File.readlines(dictionary_file_name)
    @dictionary.each do |line|
      line.chomp!
    end
    @current_words = []
    @all_seen_words = Hash.new { |h,k| h[k] = [] }
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
  
  def build_path(target)
    path_words = [target]
    parent_word = target
    until parent_word.nil?
      child_word = parent_word
      parent_word = @all_seen_words[child_word]
      path_words << parent_word
    end
    
    path_words
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
    @all_seen_words[source] = nil
    until @current_words.empty?
      new_current_words = []
      @current_words.each do |word|
        new_current_words = explore_current_words(word, new_current_words)
      end
      p "Size of new_current_words: #{new_current_words.count}"
      @current_words = new_current_words
      break if new_current_words.include?(target)
    end
    build_path(target)
  end
  
  def explore_current_words(word, new_current_words)
    # @all_seen_words[word] = []
    adjacents = adjacent_words(word)
    adjacents.each do |adjacent_wrd|
      next if @all_seen_words.key?(adjacent_wrd)
      @all_seen_words[adjacent_wrd] = word
      new_current_words << adjacent_wrd
    end
    
    new_current_words.each do |word|
      puts "Word: #{word} Word Parent: #{@all_seen_words[word]}"
    end
  end
end

word_chainer = WordChainer.new('dict.txt')
# p word_chainer.dictionary.include?('blimp')
# p word_chainer.one_letter_difference?('foo','fbb')
p word_chainer.run('market', 'cancer')