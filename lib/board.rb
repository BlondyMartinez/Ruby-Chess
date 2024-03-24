require_relative 'pieces'
require_relative 'player'

class Board
    attr_reader :board, :pieces

    def initialize(pieces)
        @board = Array.new(8) { Array.new(8, ' ') }
        @letters = ('A'..'H').to_a
        @pieces = pieces
        add_pieces(pieces)
    end
    
    def display
        letter_index = @letters.length - 1
        
        puts "\n     1   2   3   4   5   6   7   8"
        puts "   _________________________________"

        @board.reverse.each_with_index do |row, index|
            puts "#{@letters[letter_index]}  | " + row_pieces_to_symbols(row).join(' | ') + " |  #{@letters[letter_index]}"
            puts '   |---|---|---|---|---|---|---|---|' if index != @board.length - 1
            letter_index -= 1
        end
        
        puts '   ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾' 
        puts "     1   2   3   4   5   6   7   8\n"
    end

    def add_pieces(pieces)
        pieces.each do |row|
            row.each do |piece|
                x, y = piece.position
                @board[x][y] = piece
            end
        end
    end

    def update_piece_pos(piece, new_position = nil)
        x, y = piece.position
        @board[x][y] = ' '

        return if new_position.nil?

        x, y = new_position
        piece.position = new_position
        @board[x][y] = piece
    end

    def slot_empty?(slot)
        x, y = slot
        @board[x][y] == ' '
    end

    def row_pieces_to_symbols(row)
        row.map { |piece| piece == ' ' ? ' ' : piece.symbol }
    end

    def piece_at(pos)
        x, y = pos
        return @board[x][y] if @board[x][y].is_a?(Piece)
        nil
    end

    def castle(rook, king, type, board) 
        return nil if rook.has_moved || !king.can_castle?(board) 

        path_clear = rook.get_path_to(king.position).all? { |slot| slot_empty?(slot) }
        return nil if !path_clear

        k_offset = type == 'short' ? 2 : -2
        king_new_pos = [king.position[0], king.position[1] + k_offset]

        return nil if king.in_check?(board, king_new_pos)
        
        update_piece_pos(king, king_new_pos)
        
        r_offset = type == 'short' ? -2 : +3
        update_piece_pos(rook, [rook.position[0], rook.position[1] + r_offset])
    end
end