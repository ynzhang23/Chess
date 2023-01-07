# frozen-string-literal: true

require './lib/pieces/pawn'
require './lib/board'

describe WhitePawn do
  subject(:pawn) { WhitePawn.new(1, 0) }
  subject(:board) { Board.new }

  describe '#update_next_moves' do
    context 'When there are no valid moves' do
      it 'Returns an empty array' do
        board.positions[2][0] = 'B'
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
      subject(:temp_pawn) { WhitePawn.new(3, 3) }

      it 'Returns an array with valid moves' do
        answer = [[4, 3]]
        temp_pawn.update_next_moves(board)
        expect(temp_pawn.next_moves).to eql(answer)
      end
    end

    context 'When there is a piece diagonal right' do
      subject(:pawn_to_take) { WhitePawn.new(2, 1) }

      it 'Returns the valid move' do
        board.positions[2][1] = pawn_to_take
        pawn.update_next_moves(board)
        expect(pawn.next_moves).to eql([[2, 0], [3, 0], [2, 1]])
      end
    end

    context 'When there is a piece diagonal left' do
      subject(:pawn_to_take) { WhitePawn.new(2, 0) }
      subject(:temp_pawn) { WhitePawn.new(1, 1) }

      it 'Returns the valid move' do
        board.positions[2][0] = pawn_to_take
        temp_pawn.update_next_moves(board)
        expect(temp_pawn.next_moves).to eql([[2, 1], [3, 1], [2, 0]])
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

      it "Updates pawn's next_moves" do
        pawn.update_position(board, [2, 0], [1, 0])
        answer = [[3, 0]]
        expect(pawn.next_moves).to eql(answer)
      end

      it "Changes pawn's old position to empty" do
        pawn.update_position(board, [2, 0], [1, 0])
        old_position = board.positions[1][0]
        expect(old_position).to eql("-")
      end
    end
  end
end