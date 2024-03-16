require_relative "../lib/pieces"
require_relative "../lib/board"

# frozen_string_literal: true

describe "Pieces" do 
    describe "Piece movement" do
        it "allows pieces to move to an empty slot" do
            player1 = Player.new('black')
            player2 = Player.new('white')
            board = Board.new(player1.pieces.concat(player2.pieces))
        
            piece_to_move = player1.pieces[0][0] 
            initial_position = piece_to_move.position
            target_position = [3, 0]  
            
            board.update_piece_pos(piece_to_move, target_position)
        
            
            expect(piece_to_move.position).to eq(target_position)
            expect(board.slot_empty?(initial_position)).to be true
        end
      
        it "prevents pieces from moving to an occupied slot" do
            player1 = Player.new('black')
            player2 = Player.new('white')
            board = Board.new(player1.pieces.concat(player2.pieces))
          
            obstructing_piece_position = [3, 0]
            board.update_piece_pos(player2.pieces[0][1], obstructing_piece_position)
          
            piece_to_move = player1.pieces[0][0] 
            initial_position = piece_to_move.position
            target_position = [3, 0]  
          
            board.update_piece_pos(piece_to_move, target_position) if piece_to_move.valid_move?(target_position, board)
          
            expect(piece_to_move.position).to eq(initial_position)
            expect(board.slot_empty?(target_position)).to be false
          end
    end
end