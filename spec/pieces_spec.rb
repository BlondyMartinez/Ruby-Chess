require_relative "../lib/pieces"

# frozen_string_literal: true

describe "Pieces" do 
    it "validate moves of king" do
        king = King.new
        king.position = [0, 3]
        expect(king.valid_move?([0,5])).to eq(false)
        expect(king.valid_move?([2,5])).to eq(false)
        expect(king.valid_move?([0,4])).to eq(true)
        expect(king.valid_move?([1,3])).to eq(true)
    end

    it "validate moves of knight" do
        knight = Knight.new
        knight.position = [0, 1]
        expect(knight.valid_move?([1, 3])).to eq(true)
        expect(knight.valid_move?([2, 2])).to eq(true)
        expect(knight.valid_move?([3, 3])).to eq(false)
        expect(knight.valid_move?([4, 1])).to eq(false)
    end

    it "validates moves of rook" do
        rook = Rook.new
        rook.position = [0, 0]
        expect(rook.valid_move?([0, 5])).to eq(true)
        expect(rook.valid_move?([2, 5])).to eq(false)
    end
    
    it "validates moves of bishop" do
        bishop = Bishop.new
        bishop.position = [0, 0]
        expect(bishop.valid_move?([2, 2])).to eq(true)
        expect(bishop.valid_move?([0, 3])).to eq(false)
    end
    
    it "validates moves of queen" do
        queen = Queen.new
        queen.position = [0, 0]
        expect(queen.valid_move?([0, 5])).to eq(true)
        expect(queen.valid_move?([1, 3])).to eq(false)
        expect(queen.valid_move?([3, 3])).to eq(true)
    end
end