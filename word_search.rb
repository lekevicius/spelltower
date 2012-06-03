require './lib/dictionary_tree'

module SpellTower
  class WordSearch
    def initialize grid_array
      @grid = grid_array
      reset_used
      @word_tree = DictionaryTree.new 'resources/words.txt'
    end

    def find_best_words limit
      character_paths = []

      @grid.each_with_index do |column, x|
        column.each_with_index do |character, y|
          # puts "#{ letter_at(x, y) } #{x}:#{y} Nearby: #{ nearby_unused(x, y).size }"
          character_paths << [[x, y]] unless character == '?' or character == '/'
        end
      end

      found_new_words = true
      word_count = character_paths.size
      current_length = 2

      while found_new_words
        # puts "Looking for #{current_length} characters long words..."
        found_new_words = false
        # array_length_histogram character_paths, current_length
        character_paths = create_path_subtrees character_paths, current_length
        # array_length_histogram character_paths, current_length
        filter_by_dictionary character_paths, current_length if current_length > 2
        # array_length_histogram character_paths, current_length
        new_word_count = character_paths.size
        # puts "There were #{ word_count } before. Now there are #{ new_word_count }. Found #{ new_word_count - word_count } new words."
        found_new_words = true if new_word_count > word_count
        word_count = new_word_count
        current_length += 1
      end

      character_paths.delete_if { |path| ! @word_tree.word_exists(path_to_word(path)) }
      array_length_histogram character_paths, current_length

      words = []
      character_paths.each { |path| words << { word: path_to_word(path), path: path } }
      words = filter_by_unique_hash_value(words, :word)
      words.sort_by { |obj| obj[:word].length }.reverse.slice(0..(limit - 1))
    end

    def filter_by_unique_hash_value array, key
      unique_values = []
      array.delete_if do |hash|
        is_unique = ! unique_values.include?(hash[key])
        unique_values << hash[key] if is_unique
        ! is_unique
      end
    end

    def array_length_histogram array, limit
      puts '-' * 40
      limit.times do |i|
        count = 0
        array.each { |item| count += 1 if item.size == i + 1 }
        puts "#{ '*' * (i + 1) }#{ ' ' * (20 - i) } #{ i + 1 } long: #{ count } words"
      end
      puts '-' * 40
      puts
    end

    def used (x, y)
      @used.include? "#{x}.#{y}"
    end

    def reset_used
      @used = []
    end

    def use (x, y)
      @used << "#{x}.#{y}"
    end

    def letter_at (x, y)
      @grid[x][y]
    end

    def nearby_unused(x, y)
      nearby_unused = []

      nearby_unused << [x - 1, y - 1] if x > 0 and y > 0
      nearby_unused << [x    , y - 1] if            y > 0
      nearby_unused << [x + 1, y - 1] if x < 8 and y > 0
      nearby_unused << [x - 1, y    ] if x > 0
      nearby_unused << [x + 1, y    ] if x < 8
      nearby_unused << [x - 1, y + 1] if x > 0 and y < 11
      nearby_unused << [x    , y + 1] if            y < 11
      nearby_unused << [x + 1, y + 1] if x < 8 and y < 11

      nearby_unused.delete_if do |coords|
        used(coords[0], coords[1]) ||
        letter_at(coords[0], coords[1]) == '?' ||
        letter_at(coords[0], coords[1]) == '/'
      end
    end

    def create_path_subtrees paths, length
      # length - what we are looking for

      new_subtrees = []

      extendable = []
      paths.each do |path|
        extendable << path.clone if path.length == length - 1
      end

      extendable.each do |path|
        start = path.pop
        reset_used
        path.each { |coords| use(coords[0], coords[1]) }

        nearby_unused(start[0], start[1]).each do |new_segment|
          subtree = []
          path.each { |segment| subtree << segment }
          subtree << start
          subtree << new_segment
          new_subtrees << subtree
        end
      end

      if length < 4
        paths.delete_if { |path| path.length == length - 1 }
      end

      paths.concat new_subtrees
    end

    def path_to_word(path)
      word = []
      path.each do |coords|
        word << letter_at(coords[0], coords[1])
      end
      word.join
    end

    def filter_by_dictionary(paths, length)
      paths.delete_if { |path| path.length == length and ! @word_tree.start_exists(path_to_word(path)) }
    end
  end
end
