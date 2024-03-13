require_relative 'pieces'

class Player
    attr_reader :pieces

    def initialize(color)
        @pieces = [major_pieces_row(color), pawn_row(color)]
    end

    def major_pieces_row(color)
        ['left', 'right'].flat_map do |side|
            [
                Rook.new(color, side),
                Knight.new(color, side),
                Bishop.new(color, side),
                Queen.new(color),
                King.new(color),
                Bishop.new(color, side),
                Knight.new(color, side),
                Rook.new(color, side)
            ]
        end
    end
    
    def pawn_row(color)
        Array.new(8) { |index| Pawn.new(color, index) }
    end
end