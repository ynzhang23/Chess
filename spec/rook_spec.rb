# frozen-string-literal: true

require './lib/pieces/rook'
require './lib/board'

describe WhiteRook do
  subject(:rook) { WhiteRook.new(0, 0) }
  subject(:board) { Board.new }

  describe '#find_openings' do
    context 'When there are no openings' do
      it 'Returns an empty array' do
        openings = rook.find_openings(board)
        expect(openings).to eql([])
      end
    end

    context 'When there is an opening top' do
      before do
        # Remove the pawn in front of it
        board.positions[1][0] = '-'
      end
      it 'Returns an array with "up"' do
        openings = rook.find_openings(board)
        answer = ['up']
        expect(openings).to eql(answer)
      end
    end

    context 'When there are openings to the right and top' do
      # Place rook on a3 & block its forward path
      subject(:a3_rook) { WhiteRook.new(2, 0) }

      it 'Returns an array with "up" and "right"' do
        openings = a3_rook.find_openings(board)
        answer = ['up', 'right']
        expect(openings).to eql(answer)
      end
    end
  end

  describe '#update_next_moves' do
    context 'When there are no valid moves' do
      it 'Returns an empty array' do
        rook.update_next_moves(board)
        expect(rook.next_moves).to eql([])
      end
    end

    context 'When there are valid moves up' do
      subject(:temp_board) { Board.new }
      before do
        # Remove the pawn in front of it
        temp_board.positions[1][0] = '-'
      end

      it 'Returns an array with valid moves' do
        rook.update_next_moves(temp_board)
        answer = [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0]]
        expect(rook.next_moves).to eql(answer)
      end
    end

    context 'When there are valid moves right' do
      subject(:temp_board) { Board.new }
      subject(:temp_rook) { WhiteRook.new(2, 0) }
      before do
        # Block the vertical path
        temp_board.positions[3][0] = 'BLOCK'
      end

      it 'Returns an array with valid moves' do
        temp_rook.update_next_moves(temp_board)
        # Answer is the entire rank except for rook's place
        answer = []
        7.times do |num|
          num += 1
          answer.push([2, num])
        end
        expect(temp_rook.next_moves).to eql(answer)
      end
    end

    context 'When there are valid moves left' do
      subject(:temp_board) { Board.new }
      subject(:temp_rook) { WhiteRook.new(2, 7) }
      before do
        # Block the vertical path
        temp_board.positions[3][7] = 'BLOCK'
      end

      it 'Returns an array with valid moves' do
        temp_rook.update_next_moves(temp_board)
        # Answer is the entire rank except for rook's place
        answer = []
        7.times do |num|
          answer.push([2, num])
          num += 1
        end
        answer.reverse!
        expect(temp_rook.next_moves).to eql(answer)
      end
    end

    context 'When there are valid moves down' do
      subject(:temp_rook) { WhiteRook.new(5, 0) }

      it 'Returns an array with valid moves' do
        board.positions[5][1] = 'BLOCK'
        answer = [[4, 0], [3, 0], [2, 0]]
        temp_rook.update_next_moves(board)
        expect(temp_rook.next_moves).to eql(answer)
      end
    end

    context 'When there are valid moves on all sides' do
      subject(:temp_rook) { WhiteRook.new(3, 3)}

      it 'Returns an array with valid moves' do
        board.positions[3][0] = 'BLOCK'
        board.positions[3][6] = 'BLOCK'
        answer = [[4, 3], [5, 3], [2, 3], [3, 2], [3, 1], [3, 4], [3, 5]]
        temp_rook.update_next_moves(board)
        expect(temp_rook.next_moves).to eql(answer)
      end
    end
  end

  describe '#update_position' do
    context 'When you move rooks from A1 to A3' do
      before do
        allow(board).to receive(:puts)
      end

      it "Changes rook's current position" do
        rook.update_position(board, [2, 0], [0, 0])
        expect(rook.current_position).to eql([2, 0])
      end

      it "Updates rook's next_moves" do
        board.positions[3][0] = 'B'
        rook.update_position(board, [2, 0], [0, 0])
        answer = []
        7.times do |num|
          num += 1
          answer.push([2, num])
        end
        expect(rook.next_moves).to eql(answer)
      end

      it "Changes rook's old position to empty" do
        rook.update_position(board, [2, 0], [0, 0])
        old_position = board.positions[0][0]
        expect(old_position).to eql("-")
      end
    end
  end
end