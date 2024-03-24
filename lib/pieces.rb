require_relative 'board'

class Piece
    attr_reader :symbol, :move_offsets, :color, :initial_position
    attr_accessor :position, :alive, :has_moved

    def initialize(symbol, move_offsets, initial_position, color)
        @symbol = symbol
        @move_offsets = move_offsets
        @initial_position = initial_position
        @position = @initial_position
        @has_moved = false
        @alive = true
        @color = color
    end

    def valid_move?(target_position, board)
        target_piece = board.piece_at(target_position)

        return false if !target_piece.nil? && target_piece&.color == @color
        
        if self.is_a?(Pawn)
            return self.can_capture?(board, target_position) if self.is_trying_to_capture?(target_position)
        end

        return false unless generate_possible_moves(board).include?(target_position)
        
        if !self.is_a?(Knight)
            path = get_path_to(target_position)
            
            path.each do |pos|
                x, y = pos
                return false unless board.slot_empty?([x, y])
            end
        end
    
        true
    end
    
    def get_path_to(target_position)
        x1, y1 = @position
        x2, y2 = target_position
        dx = (x2 - x1).positive? ? 1 : (x2 - x1).negative? ? -1 : 0
        dy = (y2 - y1).positive? ? 1 : (y2 - y1).negative? ? -1 : 0
      
        path = []
        x, y = x1 + dx, y1 + dy
        while [x, y] != target_position
            path << [x, y]
            x += dx
            y += dy
        end
        path
    end

    def generate_possible_moves(board)
        possible_moves = []
    
        @move_offsets.each do |offset|
            x = @position[0] + offset[0]
            y = @position[1] + offset[1]
            possible_moves << [x, y] if x.between?(0, 7) && y.between?(0, 7)
        end
    
        possible_moves
    end

    def got_captured(player)
        piece = player.pieces.flatten.find { |piece| piece.initial_position == @initial_position }
        piece&.alive = false if piece
        @alive = false
    end
end

class King < Piece
    def initialize(color)
        symbol = color == 'white' ? '♔' : '♚'
        move_offsets = [[0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [-1, -1], [1, -1], [-1, 1]]
        position = color == 'white' ? [0, 4] : [7, 4];
        super(symbol, move_offsets, position, color)
    end

    def can_castle?(board)
        !self.has_moved && !in_check?(board);
    end

    def in_check?(board, position = @position)
        board.pieces.each do |row|
            row.each do |piece|
                next if piece.nil? || piece.color == @color 

                piece.generate_possible_moves(board).each do |move|
                    return true if move == position
                end
            end
        end

        false 
    end

    def checkmated?(board)
        possible_positions = generate_possible_moves(board).select { |slot| board.slot_empty?(slot) }
        possible_positions.all? { |pos| in_check?(board, pos)}
    end
end

class Queen < Piece
    def initialize(color)
        symbol = color == 'white' ? '♕' : '♛'
        relative_move_offsets =  [[0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [-1, -1], [1, -1], [-1, 1]]
        position = color == 'white' ? [0, 3] : [7, 3];
        super(symbol,  generate_move_offsets(relative_move_offsets), position, color)
    end
end

class Rook < Piece
    def initialize(color, side)
        symbol = color == 'white' ? '♖' : '♜'
        relative_move_offsets = [[0, 1], [0, -1], [1, 0], [-1, 0]]
        position = color == 'white' ? (side == 'left' ? [0, 0] : [0, 7]) : (side == 'left' ? [7, 0] : [7, 7])
        super(symbol,  generate_move_offsets(relative_move_offsets), position, color)
    end
end


class Knight < Piece
    def initialize(color, side)
        symbol = color == 'white' ? '♘' : '♞'
        move_offsets = [[1, 2], [-1, -2], [-1, 2], [1, -2], [2, 1], [-2, -1], [-2, 1], [2, -1]]
        position = color == 'white' ? (side == 'left' ? [0, 1] : [0, 6]) : (side == 'left' ? [7, 1] : [7, 6])
        super(symbol, move_offsets, position, color)
    end
end

class Bishop < Piece
    def initialize(color, side)
        symbol = color == 'white' ? '♗' : '♝'
        relative_move_offsets = [[1, 1], [-1, -1], [1, -1], [-1, 1]]
        position = color == 'white' ? (side == 'left' ? [0, 2] : [0, 5]) : (side == 'left' ? [7, 2] : [7, 5])
        super(symbol, generate_move_offsets(relative_move_offsets), position, color)
    end
end

class Pawn < Piece
    attr_reader :capturing_offsets

    def initialize(color, index)
        symbol = color == 'white' ? '♙' : '♟︎'

        move_offsets = color == 'white' ? [[2, 0], [1, 0]] : [[-2, 0], [-1, 0]]
        @capturing_offsets = color == 'white' ? [[1, 1], [1, -1]] : [[-1, 1], [-1, -1]]
        position = color == 'white' ? [1, index] : [6, index];

        super(symbol, move_offsets, position, color)
    end

    def first_move
        self.has_moved = true
        move_offsets.delete_if { |offset| offset == [2, 0] || offset == [-2, 0] }
    end

    def is_trying_to_capture?(target_position) 
        if (@color == 'white')
            x = target_position[0] + self.position[0]
            y = target_position[1] + self.position[1]
        else
            x = target_position[0] - self.position[0] 
            y = target_position[1] - self.position[1] 
        end

        capturing_offsets.any? { |offset| offset == [x, y] }
    end

    def can_capture?(board, target_position)
        x, y = target_position
        !board.slot_empty?(target_position) && board.board[x][y].color != self.color
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