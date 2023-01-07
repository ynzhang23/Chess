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

  describe '#update_position' do
    context 'When you move king from E1 to E2' do
      before do
        allow(board).to receive(:puts)
      end

      it "Changes king's current position" do
        king.update_position(board, [1, 4], [0, 4])
        expect(king.current_position).to eql([1, 4])
      end

      it "Updates king's next_moves" do
        king.update_position(board, [1, 4], [0, 4])
        answer = [[2, 4], [0, 4], [2, 3], [2, 5]]
        expect(king.next_moves).to eql(answer)
      end

      it "Changes king's old position to empty" do
        king.update_position(board, [1, 4], [0, 4])
        old_position = board.positions[0][4]
        expect(old_position).to eql("-")
      end
    end
  end
end