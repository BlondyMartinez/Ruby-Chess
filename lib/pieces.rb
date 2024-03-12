class Piece
    attr_reader :symbol, :possible_moves

    def initialize(symbol, possible_moves)
        @symbol = symbol
        @possible_moves = possible_moves
    end
end

class King
    attr_reader :piece

    def initialize(color = 'white')
        symbol = color == 'white' ? '♔' : '♚'
        possible_moves = [[0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [-1, -1], [1, -1], [-1, 1]]
        @piece = Piece.new(symbol, possible_moves)
    end

end

class Queen
    attr_reader :piece

    possible_moves = []

    def initialize(color = 'white')
        symbol = color == 'white' ? '♕' : '♛'
        possible_moves = []
        @piece = Piece.new(symbol, possible_moves)
    end
end

class Rook
    attr_reader :piece

    def initialize(color = 'white')
        symbol = color == 'white' ? '♖' : '♜'
        possible_moves = []
        @piece = Piece.new(symbol, possible_moves)
    end
end


class Knight
    attr_reader :piece

    def initialize(color = 'white')
        symbol = color == 'white' ? '♘' : '♞'
        possible_moves = [[1, 2], [-1, -2], [-1, 2], [1, -2], [2, 1], [-2, -1], [-2, 1], [2, -1]]
        @piece = Piece.new(symbol, possible_moves)
    end
end

class Bishop
    attr_reader :piece

    possible_moves = []

    def initialize(color = 'white')
        symbol = color == 'white' ? '♗' : '♝'
        @piece = Piece.new(symbol, possible_moves)
    end
end

class Pawn
    attr_reader :piece

    def initialize(color = 'white')
        symbol = color == 'white' ? '♙' : '♟︎'

        white_moves = [[2, 0], [1, 0], [1, 1], [1, -1]]
        black_moves = [[-2, 0], [-1, 0], [-1, 1], [-1, -1]]
        possible_moves = color == 'white' ? white_moves : black_moves

        @piece = Piece.new(symbol, possible_moves)
    end
end