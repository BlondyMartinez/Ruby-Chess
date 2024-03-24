require_relative '../lib/pieces'
require_relative '../lib/player'
require_relative '../lib/board'

describe 'Board' do
    it 'initialize' do
        player1 = Player.new('black')
        player2 = Player.new('white')

        board = Board.new(player1.pieces.concat(player2.pieces))

        expect(board.board.map { |row| board.row_pieces_to_symbols(row) }).to eq([['♖', '♘', '♗', '♕', '♔', '♗', '♘', '♖'],
                                                                                ['♙', '♙', '♙', '♙', '♙', '♙', '♙', '♙'],
                                                                                [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                                                                                [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                                                                                [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                                                                                [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                                                                                ['♟︎', '♟︎', '♟︎', '♟︎', '♟︎', '♟︎', '♟︎', '♟︎'],
                                                                                ['♜', '♞', '♝', '♛', '♚', '♝', '♞', '♜']])
    end

    it 'update piece positions' do 
        player1 = Player.new('black')
        player2 = Player.new('white')

        board = Board.new(player1.pieces.concat(player2.pieces))

        board.update_piece_pos(player1.pieces[0][0], [3, 0])

        expect(board.board.map { |row| board.row_pieces_to_symbols(row) }).to eq([['♖', '♘', '♗', '♕', '♔', '♗', '♘', '♖'],
                                                                                ['♙', '♙', '♙', '♙', '♙', '♙', '♙', '♙'],
                                                                                [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                                                                                ['♜', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                                                                                [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                                                                                [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                                                                                ['♟︎', '♟︎', '♟︎', '♟︎', '♟︎', '♟︎', '♟︎', '♟︎'],
                                                                                [' ', '♞', '♝', '♛', '♚', '♝', '♞', '♜']])
    end

    it 'delete piece' do 
        player1 = Player.new('black')
        player2 = Player.new('white')

        board = Board.new(player1.pieces.concat(player2.pieces))

        board.update_piece_pos(player1.pieces[0][0])

        expect(board.board.map { |row| board.row_pieces_to_symbols(row) }).to eq([['♖', '♘', '♗', '♕', '♔', '♗', '♘', '♖'],
                                                                                ['♙', '♙', '♙', '♙', '♙', '♙', '♙', '♙'],
                                                                                [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                                                                                [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                                                                                [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                                                                                [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
                                                                                ['♟︎', '♟︎', '♟︎', '♟︎', '♟︎', '♟︎', '♟︎', '♟︎'],
                                                                                [' ', '♞', '♝', '♛', '♚', '♝', '♞', '♜']])
    end

    describe "#Castle" do
        it "allows short castle when path is clear" do
            player1 = Player.new('black')
            player2 = Player.new('white')

            board = Board.new(player1.pieces.concat(player2.pieces))
            board.board[7][5] = ' ' 
            board.board[7][6] = ' '

            rook = board.piece_at([7, 7])
            king = board.piece_at([7, 4])

            expect(king.can_castle?(board)).to be true
            expect(rook.has_moved).to be false

            board.castle(rook, king, 'short', board)
            expect(rook.position).to eq([7, 5])
            expect(king.position).to eq([7, 6])
        end

        it "allows long castle when path is clear" do
            player1 = Player.new('black')
            player2 = Player.new('white')

            board = Board.new(player1.pieces.concat(player2.pieces))
            board.board[7][1] = ' ' 
            board.board[7][2] = ' '
            board.board[7][3] = ' '

            rook = board.piece_at([7, 0])
            king = board.piece_at([7, 4])

            board.castle(rook, king, 'long', board)
            expect(rook.position).to eq([7, 3])
            expect(king.position).to eq([7, 2])
        end

        it "doesnt allow castle when path isnt clear" do 
            player1 = Player.new('black')
            player2 = Player.new('white')

            board = Board.new(player1.pieces.concat(player2.pieces))

            rook = board.piece_at([7, 0])
            king = board.piece_at([7, 4])

            expect(board.castle(rook, king, 'long', board)).to eq(nil)
        end
    end
end