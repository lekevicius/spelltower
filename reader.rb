require 'chunky_png'

module SpellTower
  class Reader
    attr_reader :output

    def initialize input_file
      input_image = ChunkyPNG::Image.from_file input_file
      reference_image = ChunkyPNG::Image.from_file 'resources/letters.png'

      input_image_data = parse_input_image input_image
      reference_image_data = parse_reference_image reference_image

      @output = analyze_input input_image_data, reference_image_data
    end

    private

    def parse_input_image image
      image_data = {}
      12.times do |i|
        image_data[i] = {}
        9.times do |j|
          image_area = image.crop(6 + (j * 70), 120 + (i * 70), 69, 69)
          image_data[i][j] = image_to_data_array(image_area)
        end
      end
      image_data
    end

    def parse_reference_image image
      letter_characters = %w{A B C D E F G H I J K L M N O P Q R S T U V W X Y Z}
      image_data = {}
      3.times do |i|
        10.times do |j|
          unless i == 2 and j > 5
            image_data[letter_characters[ i * 10 + j ]] = image_to_data_array(image.crop(1 + (j * 96), 1 + (i * 96), 69, 69))
          end
        end
      end
      image_data['?'] = image_to_data_array(image.crop(1 + (9 * 96), 1 + (8 * 96), 69, 69))
      image_data
    end

    def image_to_data_array image
      data_array = []
      image.height.times do |y|
        row_array = []
        image.row(y).each_with_index do |pixel, x|
          row_array << ChunkyPNG::Color.grayscale_teint(pixel)
        end
        data_array << row_array
      end
      data_array
    end

    # -------------------

    def analyze_input input_image_data, reference_image_data
      output = []
      9.times { output << []  }
      input_image_data.each do |i, input_image_row|
        input_image_row.each do |j, input_character|
          character_similarity = {}
          reference_image_data.each do |character, reference_character|
            character_similarity[character] = image_similarity(input_character, reference_character)
          end
          sorted_characters = character_similarity.sort_by { |character, closeness| closeness }
          closest_character = sorted_characters[0][0]
          output[j] << closest_character
        end
      end
      output
    end

    def image_similarity input_data, reference_data
      diff = 0;
      input_data.each_with_index do |row, y|
        row.each_with_index do |pixel, x|
          diff += (pixel - reference_data[y][x]).abs
        end
      end
      diff
    end
  end
end
