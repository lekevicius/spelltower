require 'colorize'

module SpellTower
  class Visualizer
    attr_writer :grid

    def initialize grid_array
      @grid = grid_array
    end

    def visualize word_object
      padding = 3
      puts ' ' * padding + '+' + '-' * 9 + '+'
      12.times do |y|
        print ' ' * padding + '|'
        9.times do |x|
          grid_coordinates_array = [x, y]
          if @grid[x][y] == '?'
            print '#'.black
          elsif @grid[x][y] == '/'
            print ' '
          elsif word_object[:path].include? grid_coordinates_array
            character = @grid[x][y].dup
            if word_object[:path][0] == grid_coordinates_array
              print character.red
            else
              print character.yellow
            end
          else
            print @grid[x][y]
          end
        end
        print '|'

        if    y == 0 then print ' ' * padding + 'Word:'.underline
        elsif y == 1 then print ' ' * padding + word_object[:word].dup.blue
        elsif y == 3 then print ' ' * padding + 'Score:'.underline
        end

        puts
      end
      puts ' ' * padding + '+' + '-' * 9 + '+'
    end
  end
end
