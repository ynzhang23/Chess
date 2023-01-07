# frozen-string-literal: true

require './lib/pieces/queen'
require './lib/board'

describe WhiteQueen do
  subject(:queen) { WhiteQueen.new(0, 3) }
  subject(:board) { Board.new }

  describe '#find_openings' do
    context 'When there are no openings' do
      it 'Returns an empty array' do
        openings = queen.find_openings(board)
        expect(openings).to eql([])
      end
    end

    context 'When there is an opening up' do
      before do
        # Remove the pawn diagonal to its up
        board.positions[1][3] = '-'
      end
      it 'Returns an array with "up"' do
        openings = queen.find_openings(board)
        answer = ['up']
        expect(openings).to eql(answer)
      end
    end

    context 'When there are openings to everywhere' do
      # Place queen on a3 & block its forward path
      subject(:a3_queen) { WhiteQueen.new(3, 3) }

      it 'Returns an array with all directions' do
        openings = a3_queen.find_openings(board)
        answer = ['up', 'down', 'left', 'right', 'up_left', 'up_right', 'down_left', 'down_right']
        expect(openings).to eql(answer)
      end
    end
  end

  describe '#update_next_moves' do
    context 'When there are no valid moves' do
      it 'Returns an empty array' do
        queen.update_next_moves(board)
        expect(queen.next_moves).to eql([])
      end
    end

    context 'When there are valid moves on all sides' do
      subject(:temp_queen) { WhiteQueen.new(3, 3)}

      it 'Returns an array with valid moves' do
        answer = [[4, 3], [5, 3], [2, 3], [3, 2], [3, 1], [3, 0], [3, 4], [3, 5], [3, 6], [3, 7], [4, 2], [5, 1], [4, 4], [5, 5], [2, 2], [2, 4]]
        temp_queen.update_next_moves(board)
        expect(temp_queen.next_moves).to eql(answer)
      end
    end
  end

  describe '#update_position' do
    context 'When you move queens from D1 to D4' do
      before do
        allow(board).to receive(:puts)
      end

      it "Changes queen's current position" do
        queen.update_position(board, [3, 3], [0, 3])
        expect(queen.current_position).to eql([3, 3])
      end

      it "Updates queen's next_moves" do
        queen.update_position(board, [3, 3], [0, 3])
        answer = [[4, 3], [5, 3], [2, 3], [3, 2], [3, 1], [3, 0], [3, 4], [3, 5], [3, 6], [3, 7], [4, 2], [5, 1], [4, 4], [5, 5], [2, 2], [2, 4]]
        expect(queen.next_moves).to eql(answer)
      end

      it "Changes queen's old position to empty" do
        queen.update_position(board, [3, 3], [0, 3])
        old_position = board.positions[0][3]
        expect(old_position).to eql("-")
      end
    end
  end
end