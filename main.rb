require 'awesome_print'

require './reader'
require './word_search'
require './visualizer'

reader = SpellTower::Reader.new 'input.png'

word_search = SpellTower::WordSearch.new reader.output
best_words = word_search.find_best_words 15
# best_words.each { |hash| puts hash[:word] }

visualizer = SpellTower::Visualizer.new reader.output
best_words.each { |word_object| visualizer.visualize word_object; puts }
