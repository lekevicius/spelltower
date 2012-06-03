require './lib/object_stash'

class DictionaryTree

  def initialize filename
    basename = File.basename(filename, '.txt')
    if File.exist? "#{ File.dirname(filename) }/#{ basename }.cache"
      @tree = ObjectStash.load "#{ File.dirname(filename) }/#{ basename }.cache"
    else
      wordlist = File.open(filename, "r").read

      @words = wordlist.split("\n")
      @words.delete_if { |word| word.length < 3 }
      @words.each { |word| word.upcase! }
      @tree = recursive_split(@words)

      ObjectStash.store @tree, "#{ File.dirname(filename) }/#{ basename }.cache"
    end
  end

  def start_exists search
    !! get_path(search)
  end

  def word_exists search
    path = get_path(search)
    return false if path == false
    if path.key? '.'
      return true
    else
      return false
    end
  end

  private

  def recursive_split word_array
    word_array = split_tree(word_array)
    word_array.each do |letter, word_branch|
      word_array[letter] = recursive_split(word_branch) unless word_branch === 1
    end
    word_array
  end

  def split_tree words
    by_letter = {}
    words.each do |word|
      if word.length == 0
        by_letter['.'] = 1
        next
      end
      by_letter[word[0]] = [] unless by_letter.key? word[0]
      by_letter[word[0]] << word[1..-1]
    end
    by_letter
  end

  def get_path search
    path = @tree
    search.chars.each do |char|
      if path.key? char
        path = path[char]
      else
        return false
      end
    end
    return path
  end
end
