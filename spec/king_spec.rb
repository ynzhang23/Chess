# frozen-string-literal: true

require './lib/pieces/king'
require './lib/board'

describe WhiteKing do
  subject(:king) { WhiteKing.new(0, 4) }
  subject(:board) { Board.new }

  describe '#update_next_moves' do
    context 'When there are no valid moves' do
      it 'Returns an empty array' do
        king.update_next_moves(board)
        expect(king.next_moves).to eql([])
      end
    end

    context 'When there are valid moves on all sides' do
      subject(:temp_king) { WhiteKing.new(3, 3)}

      it 'Returns an array with valid moves' do
        answer = [[4, 3], [2, 3], [3, 2], [3, 4], [4, 2], [4, 4], [2, 2], [2, 4]]
        temp_king.update_next_moves(board)
        expect(temp_king.next_moves).to eql(answer)
      end
    end
  end

  describe '#left_castling_available?' do
    context 'When path is clear to castle' do
      it 'Returns true' do
        board.positions[0][1] = '-'
        board.positions[0][2] = '-'
        board.positions[0][3] = '-'
        result = king.left_castling_available?(board)
        expect(result).to be true
      end
    end

    context 'When rook has already moved but is back at original place' do
      it 'Returns false' do
        board.positions[0][1] = '-'
        board.positions[0][2] = '-'
        board.positions[0][3] = '-'
        left_rook = board.positions[0][0]
        left_rook.moved = true
        result = king.left_castling_available?(board)
        expect(result).to be false
      end
    end

    context 'When king has already moved but is back at original place' do
      it 'Returns false' do
        board.positions[0][1] = '-'
        board.positions[0][2] = '-'
        board.positions[0][3] = '-'
        king.moved = true
        result = king.left_castling_available?(board)
        expect(result).to be false
      end
    end

    context 'When left castle is blocked by own piece' do
      it 'Returns false' do
        board.positions[0][1] = '-'
        board.positions[0][3] = '-'
        result = king.left_castling_available?(board)
        expect(result).to be false
      end
    end

    context 'When travelled square is attacked by enemy piece' do
      let(:attacking_knight) { double('BlackKnight', color: 'black', next_moves: [[0, 3]])}
      it 'Returns false' do
        board.positions[0][1] = '-'
        board.positions[0][2] = '-'
        board.positions[0][3] = '-'

        # King goes over [0, 3] which is attacked by black knight
        board.positions[2][2] = attacking_knight

        result = king.left_castling_available?(board)
        expect(result).to be false
      end
    end

    context 'When new square is attacked by enemy piece' do
      let(:attacking_knight) { double('BlackKnight', color: 'black', next_moves: [[0, 2]])}
      it 'Returns false' do
        board.positions[0][1] = '-'
        board.positions[0][2] = '-'
        board.positions[0][3] = '-'

        # King lands on [0, 2] which is attacked by black knight
        board.positions[2][1] = attacking_knight

        result = king.left_castling_available?(board)
        expect(result).to be false
      end
    end
  end

  describe '#right_castling_available?' do
    context 'When path is clear to castle' do
      it 'Returns true' do
        board.positions[0][5] = '-'
        board.positions[0][6] = '-'
        result = king.right_castling_available?(board)
        expect(result).to be true
      end
    end

    context 'When rook has already moved but is back at original place' do
      it 'Returns false' do
        board.positions[0][5] = '-'
        board.positions[0][6] = '-'
        right_rook = board.positions[0][7]
        right_rook.moved = true
        result = king.right_castling_available?(board)
        expect(result).to be false
      end
    end

    context 'When king has already moved but is back at original place' do
      it 'Returns false' do
        board.positions[0][5] = '-'
        board.positions[0][6] = '-'
        king.moved = true
        result = king.right_castling_available?(board)
        expect(result).to be false
      end
    end

    context 'When right castle is blocked by own piece' do
      it 'Returns false' do
        board.positions[0][5] = '-'
        result = king.right_castling_available?(board)
        expect(result).to be false
      end
    end

    context 'When travelled square is attacked by enemy piece' do
      let(:attacking_knight) { double('BlackKnight', color: 'black', next_moves: [[0, 5]])}
      it 'Returns false' do
        board.positions[0][5] = '-'
        board.positions[0][6] = '-'

        # King goes over [0, 5] which is attacked by black knight
        board.positions[2][6] = attacking_knight

        result = king.right_castling_available?(board)
        expect(result).to be false
      end
    end

    context 'When new square is attacked by enemy piece' do
      let(:attacking_knight) { double('BlackKnight', color: 'black', next_moves: [[0, 6]]) }
      it 'Returns false' do
        board.positions[0][5] = '-'
        board.positions[0][6] = '-'

        # King ends at [0, 6] which is attacked by black knight
        board.positions[2][5] = attacking_knight

        result = king.right_castling_available?(board)
        expect(result).to be false
      end
    end
  end

  describe '#update_position' do
    context 'When you move king from E1 to E2' do
      before do
        allow(board).to receive(:puts)
      end

      it "Changes king's current position" do
        king.update_position(board, [1, 4], [0, 4])
        expect(king.current_position).to eql([1, 4])
      end

      it "Changes king's old position to empty" do
        king.update_position(board, [1, 4], [0, 4])
        old_position = board.positions[0][4]
        expect(old_position).to eql("-")
      end
    end

    context 'When you castle to the left' do
      before do
        allow(board).to receive(:puts)
      end

      it 'Changes the king position' do
        board.positions[0][1] = '-'
        board.positions[0][2] = '-'
        board.positions[0][3] = '-'
        king.update_position(board, [0, 2], [0, 4])
        expect(king.current_position).to eql([0, 2])
      end

      it 'Moves the rook over' do
        board.positions[0][1] = '-'
        board.positions[0][2] = '-'
        board.positions[0][3] = '-'
        king.update_position(board, [0, 2], [0, 4])
        expect(board.positions[0][3].symbol).to eql('♜')
      end
    end
  end
end

describe BlackKing do
  subject(:king) { BlackKing.new(0, 4) }
  subject(:board) { Board.new }

  describe '#left_castling_available?' do
    context 'When path is clear to castle' do
      it 'Returns true' do
        board.positions[7][1] = '-'
        board.positions[7][2] = '-'
        board.positions[7][3] = '-'
        result = king.left_castling_available?(board)
        expect(result).to be true
      end
    end

    context 'When rook has already moved but is back at original place' do
      it 'Returns false' do
        board.positions[7][1] = '-'
        board.positions[7][2] = '-'
        board.positions[7][3] = '-'
        left_rook = board.positions[7][0]
        left_rook.moved = true
        result = king.left_castling_available?(board)
        expect(result).to be false
      end
    end

    context 'When king has already moved but is back at original place' do
      it 'Returns false' do
        board.positions[7][1] = '-'
        board.positions[7][2] = '-'
        board.positions[7][3] = '-'
        king.moved = true
        result = king.left_castling_available?(board)
        expect(result).to be false
      end
    end

    context 'When left castle is blocked by own piece' do
      it 'Returns false' do
        board.positions[7][1] = '-'
        board.positions[7][3] = '-'
        result = king.left_castling_available?(board)
        expect(result).to be false
      end
    end

    context 'When travelled square is attacked by enemy piece' do
      let(:attacking_knight) { double('WhiteKnight', color: 'white', next_moves: [[7, 3]])}
      it 'Returns false' do
        board.positions[7][1] = '-'
        board.positions[7][2] = '-'
        board.positions[7][3] = '-'

        # King goes over [7, 3] which is attacked by black knight
        board.positions[5][2] = attacking_knight

        result = king.left_castling_available?(board)
        expect(result).to be false
      end
    end

    context 'When new square is attacked by enemy piece' do
      let(:attacking_knight) { double('WhiteKnight', color: 'white', next_moves: [[7, 2]])}
      it 'Returns false' do
        board.positions[7][1] = '-'
        board.positions[7][2] = '-'
        board.positions[7][3] = '-'

        # King lands on [7, 2] which is attacked by black knight
        board.positions[7][1] = attacking_knight

        result = king.left_castling_available?(board)
        expect(result).to be false
      end
    end
  end

  describe '#right_castling_available?' do
    context 'When path is clear to castle' do
      it 'Returns true' do
        board.positions[7][5] = '-'
        board.positions[7][6] = '-'
        result = king.right_castling_available?(board)
        expect(result).to be true
      end
    end

    context 'When rook has already moved but is back at original place' do
      it 'Returns false' do
        board.positions[7][5] = '-'
        board.positions[7][6] = '-'
        right_rook = board.positions[7][7]
        right_rook.moved = true
        result = king.right_castling_available?(board)
        expect(result).to be false
      end
    end

    context 'When king has already moved but is back at original place' do
      it 'Returns false' do
        board.positions[7][5] = '-'
        board.positions[7][6] = '-'
        king.moved = true
        result = king.right_castling_available?(board)
        expect(result).to be false
      end
    end

    context 'When right castle is blocked by own piece' do
      it 'Returns false' do
        board.positions[7][5] = '-'
        result = king.right_castling_available?(board)
        expect(result).to be false
      end
    end

    context 'When travelled square is attacked by enemy piece' do
      let(:attacking_knight) { double('WhiteKnight', color: 'white', next_moves: [[7, 5]])}
      it 'Returns false' do
        board.positions[7][5] = '-'
        board.positions[7][6] = '-'

        # King goes over [7, 5] which is attacked by black knight
        board.positions[5][6] = attacking_knight

        result = king.right_castling_available?(board)
        expect(result).to be false
      end
    end

    context 'When new square is attacked by enemy piece' do
      let(:attacking_knight) { double('WhiteKnight', color: 'white', next_moves: [[7, 6]]) }
      it 'Returns false' do
        board.positions[7][5] = '-'
        board.positions[7][6] = '-'

        # King ends at [7, 6] which is attacked by black knight
        board.positions[5][5] = attacking_knight

        result = king.right_castling_available?(board)
        expect(result).to be false
      end
    end
  end

  describe '#update_position' do
    context 'When you castle to the right' do
      before do
        allow(board).to receive(:puts)
      end

      it 'Changes the king position' do
        board.positions[7][5] = '-'
        board.positions[7][6] = '-'
        king.update_position(board, [7, 6], [7, 4])
        expect(king.current_position).to eql([7, 6])
      end

      it 'Moves the rook over' do
        board.positions[7][5] = '-'
        board.positions[7][6] = '-'
        king.update_position(board, [7, 6], [7, 4])
        expect(board.positions[7][5].symbol).to eql('♖')
      end
    end
  end
end
