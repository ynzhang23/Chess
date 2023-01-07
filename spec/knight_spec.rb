# frozen-string-literal: true

require './lib/pieces/knight'
require './lib/board'

describe WhiteKnight do
  subject(:knight) { WhiteKnight.new(0, 1) }
  subject(:board) { Board.new }

  describe '#update_next_moves' do
    context 'When there are no valid moves' do
      it 'Returns an empty array' do
        board.positions[2][2] = 'B'
        board.positions[2][0] = 'B'
        knight.update_next_moves(board)
        expect(knight.next_moves).to eql([])
      end
    end

    context 'When there are valid moves on all sides' do
      subject(:temp_knight) { WhiteKnight.new(3, 3)}

      it 'Returns an array with valid moves' do
        answer = [[5, 4], [4, 5], [2, 5], [2, 1], [4, 1], [5, 2]]
        temp_knight.update_next_moves(board)
        expect(temp_knight.next_moves).to eql(answer)
      end
    end
  end

  describe '#update_position' do
    context 'When you move knight from E1 to E2' do
      before do
        allow(board).to receive(:puts)
      end

      it "Changes knight's current position" do
        knight.update_position(board, [2, 2], [0, 1])
        expect(knight.current_position).to eql([2, 2])
      end

      it "Updates knight's next_moves" do
        knight.update_position(board, [2, 2], [0, 1])
        answer = [[4, 3], [3, 4], [0, 1], [3, 0], [4, 1]]
        expect(knight.next_moves).to eql(answer)
      end

      it "Changes knight's old position to empty" do
        knight.update_position(board, [2, 2], [0, 1])
        old_position = board.positions[0][1]
        expect(old_position).to eql("-")
      end
    end
  end
end
