require_relative 'pieces'
require_relative 'player'

class Board
    attr_reader :board

    def initialize(pieces)
        @board = Array.new(8) { Array.new(8, ' ') }
        @letters = ('A'..'H').to_a
        add_pieces(pieces)
    end
    
    def display
        letter_index = @letters.length - 1
        
        puts "\n     1   2   3   4   5   6   7   8"
        puts "   _________________________________"

        @board.reverse.each_with_index do |row, index|
            puts "#{@letters[letter_index]}  | " + row.join(' | ') + " |  #{@letters[letter_index]}"
            puts '   |---|---|---|---|---|---|---|---|' if index != @board.length - 1
            letter_index -= 1
        end
        
        puts '   ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾' 
        puts "     1   2   3   4   5   6   7   8\n"
    end

    def add_pieces(pieces)
        pieces.each_with_index do |row, r_index|
            row.each_with_index do |piece, c_index|
                x, y = piece.position
                @board[x][y] = piece.symbol
            end
        end
    end

    def update_piece_pos(piece, new_position = nil)
        x, y = piece.position
        @board[x][y] = ' '

        return if new_position == nil

        x, y = new_position
        piece.position = new_position
        @board[x][y] = piece.symbol
    end

    def slot_empty?(slot)
        x, y = slot
        @board[x][y] == ' '
    end
end