require_relative 'pieces'

class Board
    def initialize
        @board = Array.new(8) { Array.new(8, ' ') }
        @letters = ('A'..'H').to_a
    end
    
    def display
        letter_index = @letters.length - 1
        
        puts "\n    1   2   3   4   5   6   7   8\n"
        puts "   _________________________________"

        @board.reverse.each_with_index do |row, index|
            puts "#{@letters[letter_index]}  | " + row.join(' | ') + " | #{@letters[letter_index]}"
            puts '   |---|---|---|---|---|---|---|---|' if index != @board.length - 1
            letter_index -= 1
        end
        
        puts '   ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾' 
        puts "\n    1   2   3   4   5   6   7   8\n"
    end
end