require_relative "../lib/pieces"
require_relative "../lib/board"

# frozen_string_literal: true

describe "Pieces" do 
    describe "#Piece movement" do
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

        it "allows pawn to capture diagonally" do 
            player1 = Player.new('black')
            player2 = Player.new('white')
            board = Board.new(player1.pieces.concat(player2.pieces))
        
            pawn = player1.pieces.flatten.find { |piece| piece.is_a?(Pawn) }
            board.update_piece_pos(pawn, [2, 2])

            pawn_to_capture = player2.pieces.flatten.find { |piece| piece.is_a?(Pawn) }
            target_position = [1, 1]

            expect(pawn.valid_move?(target_position, board)).to be true
            if pawn.valid_move?(target_position, board)
                board.update_piece_pos(pawn, target_position)
            end
        
            expect(pawn.position).to eq(target_position)
            expect(board.slot_empty?([2, 2])).to be true
        end

        it "does not allow pawn to perform initial double move if it has moved already" do 
            player1 = Player.new('black')
            player2 = Player.new('white')
            board = Board.new(player1.pieces.concat(player2.pieces))
        
            pawn = player1.pieces.flatten.find { |piece| piece.is_a?(Pawn) }
            target_position = [3, 0]
            board.update_piece_pos(pawn, target_position)
            pawn.first_move

            initial_position = pawn.position
            target_position = [5, 0]

            if pawn.valid_move?(target_position, board)
                board.update_piece_pos(pawn, target_position)
            end

            expect(pawn.has_moved).to be true
            expect(pawn.position).to eq(initial_position)
        end

        it "allows king to move one square in any direction" do
            player1 = Player.new('black')
            player2 = Player.new('white')
            board = Board.new(player1.pieces.concat(player2.pieces))
        
            king = player1.pieces.flatten.find { |piece| piece.is_a?(King) }
            king.position = [3, 3] # places the piece where no other pieces are aroud
            initial_position = king.position
            target_position = [initial_position[0] + 1, initial_position[1] + 1]

            if king.valid_move?(target_position, board)
                board.update_piece_pos(king, target_position)
            end

            expect(king.position).to eq(target_position)
        end

        it "allows queen to move diagonally" do
            player1 = Player.new('black')
            player2 = Player.new('white')
            board = Board.new(player1.pieces.concat(player2.pieces))
        
            queen = player1.pieces.flatten.find { |piece| piece.is_a?(Queen) }
            queen.position = [3, 3] # places the piece where no other pieces are aroud
            initial_position = queen.position
            target_position = [initial_position[0] + 2, initial_position[1] + 2]

            if queen.valid_move?(target_position, board)
                board.update_piece_pos(queen, target_position)
            end

            expect(queen.position).to eq(target_position)
        end

        it "allows rook to move horizontally" do
            player1 = Player.new('black')
            player2 = Player.new('white')
            board = Board.new(player1.pieces.concat(player2.pieces))
        
            rook = player1.pieces.flatten.find { |piece| piece.is_a?(Rook) }
            rook.position = [3, 3] # places the piece where no other pieces are aroud
            initial_position = rook.position
            target_position = [initial_position[0], initial_position[1] + 2]

            if rook.valid_move?(target_position, board)
                board.update_piece_pos(rook, target_position)
            end

            expect(rook.position).to eq(target_position)
        end

        it "allows knight to move in an L-shape" do
            player1 = Player.new('black')
            player2 = Player.new('white')
            board = Board.new(player1.pieces.concat(player2.pieces))
        
            knight = player1.pieces.flatten.find { |piece| piece.is_a?(Knight) }
            initial_position = knight.position
            target_position = [initial_position[0] - 2, initial_position[1] - 1]

            if knight.valid_move?(target_position, board)
                board.update_piece_pos(knight, target_position)
            end

            expect(knight.position).to eq(target_position)
        end

        it "allows bishop to move diagonally" do
            player1 = Player.new('black')
            player2 = Player.new('white')
            board = Board.new(player1.pieces.concat(player2.pieces))
        
            bishop = player1.pieces.flatten.find { |piece| piece.is_a?(Bishop) }
            bishop.position = [4, 4] # places the piece where no other pieces are aroud
            initial_position = bishop.position
            target_position = [initial_position[0] - 2, initial_position[1] - 2]

            if bishop.valid_move?(target_position, board)
                board.update_piece_pos(bishop, target_position)
            end

            expect(bishop.position).to eq(target_position)
        end
    end

    it "allows pieces to move to a slot occupied by an enemy piece" do
        player1 = Player.new('black')
        player2 = Player.new('white')
        board = Board.new(player1.pieces.concat(player2.pieces))
      
        obstructing_piece_position = [4, 3]
        board.update_piece_pos(player2.pieces[0][1], obstructing_piece_position)
      
        piece_to_move = player1.pieces[0][0] 
        board.update_piece_pos(piece_to_move, [3,3])
        initial_position = piece_to_move.position
        target_position = obstructing_piece_position
      
        expect(piece_to_move.valid_move?(target_position, board)).to be true
        if piece_to_move.valid_move?(target_position, board)
            board.piece_at(target_position).got_captured(player2)
            expect(board.piece_at(target_position).alive).to be false
            expect(player2.pieces[0][1].alive).to be false
            board.update_piece_pos(piece_to_move, target_position) 
        end


        expect(piece_to_move.position).to eq(target_position)
        expect(board.slot_empty?(initial_position)).to be true
    end

    describe "#King" do 
        it "checkmated" do
            player1 = Player.new('black')
            player2 = Player.new('white')
            board = Board.new(player1.pieces.concat(player2.pieces))

            board.board[6][4] = ' '
            board.update_piece_pos(board.piece_at([0, 3]), [3, 4])

            expect(board.piece_at([7, 4]).checkmated?(board)).to be true
        end

        it "not in check" do
            player1 = Player.new('black')
            player2 = Player.new('white')
            board = Board.new(player1.pieces.concat(player2.pieces))

            expect(board.piece_at([7, 4]).in_check?(board)).to be false
        end
        
        
        it "in check but not checkmated" do
            player1 = Player.new('black')
            player2 = Player.new('white')
            board = Board.new(player1.pieces.concat(player2.pieces))

            board.board[6][4] = ' '
            board.board[6][5] = ' '

            board.update_piece_pos(board.piece_at([0, 0]), [3, 4])

            expect(board.piece_at([7, 4]).in_check?(board)).to be true
            expect(board.piece_at([7, 4]).checkmated?(board)).to be false
        end
    end
end