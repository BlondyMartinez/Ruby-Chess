class Piece
    attr_reader :symbol, :possible_moves

    def initialize(symbol, possible_moves)
        @symbol = symbol
        @possible_moves = possible_moves
    end
end

class King
    attr_reader :piece

    POSSIBLE_MOVES = [[0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [-1, -1], [1, -1], [-1, 1]]

    def initialize(color = 'white')
        symbol = color == 'white' ? '♔' : '♚'
        @piece = Piece.new(symbol, POSSIBLE_MOVES)
    end

end