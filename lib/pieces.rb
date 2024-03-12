class Piece
    attr_reader :symbol, :move_offsets
    attr_accessor :position

    def initialize(symbol, move_offsets)
        @symbol = symbol
        @move_offsets = move_offsets
    end

    def valid_move?(coordinates)
        generate_possible_moves(@position).include?(coordinates)
    end

    def generate_possible_moves(position) 
        possible_moves = []

        @move_offsets.each do |offset|
            x = position[0] + offset[0]
            y = position[1] + offset[1]
            possible_moves.push([x, y]) if x.between?(0, 7) && y.between?(0, 7) 
        end

        possible_moves
    end
end

class King < Piece
    def initialize(color = 'white')
        symbol = color == 'white' ? '♔' : '♚'
        move_offsets = [[0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [-1, -1], [1, -1], [-1, 1]]
        super(symbol, move_offsets)
    end

end

class Queen < Piece
    def initialize(color = 'white')
        symbol = color == 'white' ? '♕' : '♛'
        relative_move_offsets =  [[0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [-1, -1], [1, -1], [-1, 1]]
        super(symbol,  generate_move_offsets(relative_move_offsets))
    end
end

class Rook < Piece
    def initialize(color = 'white')
        symbol = color == 'white' ? '♖' : '♜'
        relative_move_offsets = [[0, 1], [0, -1], [1, 0], [-1, 0]]
        super(symbol,  generate_move_offsets(relative_move_offsets))
    end
end


class Knight < Piece
    def initialize(color = 'white')
        symbol = color == 'white' ? '♘' : '♞'
        move_offsets = [[1, 2], [-1, -2], [-1, 2], [1, -2], [2, 1], [-2, -1], [-2, 1], [2, -1]]
        super(symbol, move_offsets)
    end
end

class Bishop < Piece
    def initialize(color = 'white')
        symbol = color == 'white' ? '♗' : '♝'
        relative_move_offsets = [[1, 1], [-1, -1], [1, -1], [-1, 1]]
        super(symbol, generate_move_offsets(relative_move_offsets))
    end
end

class Pawn < Piece
    def initialize(color = 'white')
        symbol = color == 'white' ? '♙' : '♟︎'

        white_moves = [[2, 0], [1, 0], [1, 1], [1, -1]]
        black_moves = [[-2, 0], [-1, 0], [-1, 1], [-1, -1]]
        move_offsets = color == 'white' ? white_moves : black_moves

        super(symbol, move_offsets)
    end
end


# utility

def generate_move_offsets(relative_offsets)
    offsets = []
  
    relative_offsets.each do |dx, dy|
      (1..7).each do |n|
        offsets << [dx * n, dy * n]
      end
    end
  
    offsets
  end