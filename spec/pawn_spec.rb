# frozen-string-literal: true

require './lib/pieces/pawn'
require './lib/board'

describe WhitePawn do
  subject(:pawn) { WhitePawn.new(1, 0) }
  subject(:board) { Board.new }

  describe '#update_next_moves' do
    context 'When there are no valid moves' do
      it 'Returns an empty array' do
        # Block it with a white pawn
        board.positions[2][0] = pawn
        pawn.update_next_moves(board)
        expect(pawn.next_moves).to eql([])
      end
    end

    context 'When it has yet to move' do
      it 'Returns two valid moves' do
        pawn.update_next_moves(board)
        expect(pawn.next_moves).to eql([[2, 0], [3, 0]])
      end
    end

    context 'When it has already moved' do
      subject(:temp_pawn) { WhitePawn.new(2, 1) }

      it 'Returns an array with valid moves' do
        answer = [[3, 1]]
        temp_pawn.update_next_moves(board)
        expect(temp_pawn.next_moves).to eql(answer)
      end
    end

    context 'When there is a piece diagonal right' do
      subject(:pawn_to_take) { BlackPawn.new(2, 1) }

      it 'Returns the valid move' do
        board.positions[2][1] = pawn_to_take
        pawn.update_next_moves(board)
        expect(pawn.next_moves).to eql([[2, 0], [3, 0], [2, 1]])
      end
    end

    context 'When there is a piece diagonal left' do
      subject(:pawn_to_take) { BlackPawn.new(2, 0) }
      subject(:temp_pawn) { WhitePawn.new(1, 1) }

      it 'Returns the valid move' do
        board.positions[2][0] = pawn_to_take
        temp_pawn.update_next_moves(board)
        expect(temp_pawn.next_moves).to eql([[2, 1], [3, 1], [2, 0]])
      end
    end

    context 'When white can perform an en passant on left' do
      subject(:killer_pawn) { WhitePawn.new(4, 6) }
      subject(:victim_pawn) { BlackPawn.new(4, 7) }

      it 'Has the en passsant space in next moves' do
        victim_pawn.en_passant_vulnerable = true
        board.positions[4][6] = killer_pawn
        board.positions[4][7] = victim_pawn
        answer = [[5, 6], [5, 7]]

        killer_pawn.update_next_moves(board)

        expect(killer_pawn.next_moves).to eql(answer)
      end
    end

    context 'When white can perform an en passant on right' do
      subject(:killer_pawn) { WhitePawn.new(4, 6) }
      subject(:victim_pawn) { BlackPawn.new(4, 5) }

      it 'Has the en passsant space in next moves' do
        victim_pawn.en_passant_vulnerable = true
        board.positions[4][6] = killer_pawn
        board.positions[4][5] = victim_pawn
        answer = [[5, 6], [5, 5]]

        killer_pawn.update_next_moves(board)

        expect(killer_pawn.next_moves).to eql(answer)
      end
    end
  end

  describe '#update_position' do
    context 'When you move pawn from E1 to E2' do
      before do
        allow(board).to receive(:puts)
      end

      it "Changes pawn's current position" do
        pawn.update_position(board, [2, 0], [1, 0])
        expect(pawn.current_position).to eql([2, 0])
      end

      it "Changes pawn's old position to empty" do
        pawn.update_position(board, [2, 0], [1, 0])
        old_position = board.positions[1][0]
        expect(old_position).to eql("-")
      end
    end

    context 'When white performs an en passant on the piece on its right' do
      subject(:killer_pawn) { WhitePawn.new(4, 6) }
      subject(:victim_pawn) { BlackPawn.new(4, 7) }

      before do
        allow(board).to receive(:puts)
      end

      it 'Removes the opponent' do
        board.positions[4][6] = killer_pawn
        board.positions[4][7] = victim_pawn
        victim_pawn.en_passant_vulnerable = true
        killer_pawn.update_position(board, [5, 7], [4, 6])
        expect(board.positions[4][7]).to eql('-')
      end
    end

    context 'When white performs an en passant on the piece on its left' do
      subject(:killer_pawn) { WhitePawn.new(4, 6) }
      subject(:victim_pawn) { BlackPawn.new(4, 7) }

      before do
        allow(board).to receive(:puts)
      end

      it 'Removes the opponent' do
        board.positions[4][6] = killer_pawn
        board.positions[4][5] = victim_pawn
        victim_pawn.en_passant_vulnerable = true
        killer_pawn.update_position(board, [5, 5], [4, 6])
        expect(board.positions[4][5]).to eql('-')
      end
    end
  end

  describe '#promote?' do
    context 'When white pawn is on the last rank' do
      subject(:promote_pawn) { WhitePawn.new(7, 0) }
      it 'Returns true' do
        board.positions[7][0] = promote_pawn
        result = promote_pawn.promote?
        expect(result).to be true
      end
    end

    context 'When white pawn is not on the last rank' do
      subject(:promote_pawn) { WhitePawn.new(6, 0) }
      it 'Returns false' do
        board.positions[6][0] = promote_pawn
        result = promote_pawn.promote?
        expect(result).to be false
      end
    end
  end

  describe '#promote_pawn' do
    subject(:promote_pawn) { described_class.new(7, 0) }
    before do
      allow(board).to receive(:puts)
      allow(promote_pawn).to receive(:puts)
    end

    context 'When I promote it to a knight' do
      before do
        allow(promote_pawn).to receive(:gets).and_return('4')
      end

      it 'Changes the pawn to knight' do
        board.positions[7][0] = promote_pawn
        promote_pawn.promote_pawn(board, 7, 0)
        square = board.positions[7][0].symbol
        expect(square).to eql('♞')
      end
    end

    context 'When I promote it to a queen' do
      before do
        allow(promote_pawn).to receive(:gets).and_return('a', '1')
      end

      it 'Changes the pawn to queen' do
        board.positions[7][0] = promote_pawn
        promote_pawn.promote_pawn(board, 7, 0)
        square = board.positions[7][0].symbol
        expect(square).to eql('♛')
      end
    end
  end
end

describe BlackPawn do
  subject(:pawn) { BlackPawn.new(6, 0) }
  subject(:board) { Board.new }

  describe '#update_next_moves' do
    context 'When there are no valid moves' do
      it 'Returns an empty array' do
        # Block it with a white pawn
        board.positions[5][0] = pawn
        pawn.update_next_moves(board)
        expect(pawn.next_moves).to eql([])
      end
    end

    context 'When it has yet to move' do
      it 'Returns two valid moves' do
        pawn.update_next_moves(board)
        expect(pawn.next_moves).to eql([[5, 0], [4, 0]])
      end
    end

    context 'When it has already moved' do
      subject(:temp_pawn) { BlackPawn.new(5, 1) }

      it 'Returns an array with valid moves' do
        answer = [[4, 1]]
        temp_pawn.update_next_moves(board)
        expect(temp_pawn.next_moves).to eql(answer)
      end
    end

    context 'When there is a piece diagonal right' do
      subject(:pawn_to_take) { WhitePawn.new(5, 1) }

      it 'Returns the valid move' do
        board.positions[5][1] = pawn_to_take
        pawn.update_next_moves(board)
        expect(pawn.next_moves).to eql([[5, 0], [4, 0], [5, 1]])
      end
    end

    context 'When there is a piece diagonal left' do
      subject(:pawn_to_take) { WhitePawn.new(5, 0) }
      subject(:temp_pawn) { BlackPawn.new(6, 1) }

      it 'Returns the valid move' do
        board.positions[5][0] = pawn_to_take
        temp_pawn.update_next_moves(board)
        expect(temp_pawn.next_moves).to eql([[5, 1], [4, 1], [5, 0]])
      end
    end

    context 'When black can perform an en passant on left' do
      subject(:killer_pawn) { BlackPawn.new(3, 6) }
      subject(:victim_pawn) { WhitePawn.new(3, 5) }

      it 'Has the en passsant space in next moves' do
        victim_pawn.en_passant_vulnerable = true
        board.positions[3][5] = killer_pawn
        board.positions[3][5] = victim_pawn
        answer = [[2, 6], [2, 5]]

        killer_pawn.update_next_moves(board)

        expect(killer_pawn.next_moves).to eql(answer)
      end
    end

    context 'When white can perform an en passant on right' do
      subject(:killer_pawn) { BlackPawn.new(3, 6) }
      subject(:victim_pawn) { WhitePawn.new(3, 7) }

      it 'Has the en passsant space in next moves' do
        victim_pawn.en_passant_vulnerable = true
        board.positions[3][6] = killer_pawn
        board.positions[3][7] = victim_pawn
        answer = [[2, 6], [2, 7]]

        killer_pawn.update_next_moves(board)

        expect(killer_pawn.next_moves).to eql(answer)
      end
    end
  end

  describe '#update_position' do
    context 'When you move pawn from E1 to E2' do
      before do
        allow(board).to receive(:puts)
      end

      it "Changes pawn's current position" do
        pawn.update_position(board, [2, 0], [1, 0])
        expect(pawn.current_position).to eql([2, 0])
      end

      it "Changes pawn's old position to empty" do
        pawn.update_position(board, [2, 0], [1, 0])
        old_position = board.positions[1][0]
        expect(old_position).to eql('-')
      end
    end

    context 'When white performs an en passant on the piece on its right' do
      subject(:killer_pawn) { BlackPawn.new(2, 6) }
      subject(:victim_pawn) { WhitePawn.new(2, 7) }

      before do
        allow(board).to receive(:puts)
      end

      it 'Removes the opponent' do
        board.positions[2][6] = killer_pawn
        board.positions[2][5] = victim_pawn
        victim_pawn.en_passant_vulnerable = true
        killer_pawn.update_position(board, [1, 7], [2, 6])
        expect(board.positions[2][7]).to eql('-')
      end
    end

    context 'When black performs an en passant on the piece on its left' do
      subject(:killer_pawn) { BlackPawn.new(2, 6) }
      subject(:victim_pawn) { WhitePawn.new(2, 5) }

      before do
        allow(board).to receive(:puts)
      end

      it 'Removes the opponent' do
        board.positions[2][6] = killer_pawn
        board.positions[2][5] = victim_pawn
        victim_pawn.en_passant_vulnerable = true
        killer_pawn.update_position(board, [1, 5], [2, 6])
        expect(board.positions[2][5]).to eql('-')
      end
    end
  end

  describe '#promote?' do
    context 'When white pawn is on the last rank' do
      subject(:promote_pawn) { BlackPawn.new(0, 0) }
      it 'Returns true' do
        board.positions[0][0] = promote_pawn
        result = promote_pawn.promote?
        expect(result).to be true
      end
    end

    context 'When white pawn is not on the last rank' do
      subject(:promote_pawn) { WhitePawn.new(1, 0) }
      it 'Returns false' do
        board.positions[1][0] = promote_pawn
        result = promote_pawn.promote?
        expect(result).to be false
      end
    end
  end

  describe '#promote_pawn' do
    subject(:promote_pawn) { described_class.new(0, 0) }
    before do
      allow(board).to receive(:puts)
      allow(promote_pawn).to receive(:puts)
    end

    context 'When I promote it to a knight' do
      before do
        allow(promote_pawn).to receive(:gets).and_return('4')
      end

      it 'Changes the pawn to knight' do
        board.positions[0][0] = promote_pawn
        promote_pawn.promote_pawn(board, 0, 0)
        square = board.positions[0][0].symbol
        expect(square).to eql('♘')
      end
    end

    context 'When I promote it to a rook' do
      before do
        allow(promote_pawn).to receive(:gets).and_return('2')
      end

      it 'Changes the pawn to rook' do
        board.positions[0][0] = promote_pawn
        promote_pawn.promote_pawn(board, 0, 0)
        square = board.positions[0][0].symbol
        expect(square).to eql('♖')
      end
    end
  end
end
