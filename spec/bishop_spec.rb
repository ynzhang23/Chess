# frozen-string-literal: true

require './lib/pieces/bishop'
require './lib/board'

describe WhiteBishop do
  subject(:bishop) { WhiteBishop.new(0, 2) }
  subject(:board) { Board.new }

  describe '#find_openings' do
    context 'When there are no openings' do
      it 'Returns an empty array' do
        openings = bishop.find_openings(board)
        expect(openings).to eql([])
      end
    end

    context 'When there is an opening up_right' do
      before do
        # Remove the pawn diagonal to its up right
        board.positions[1][3] = '-'
      end
      it 'Returns an array with "up"' do
        openings = bishop.find_openings(board)
        answer = ['up_right']
        expect(openings).to eql(answer)
      end
    end

    context 'When there are openings to everywhere' do
      # Place bishop on a3 & block its forward path
      subject(:a3_bishop) { WhiteBishop.new(3, 3) }

      it 'Returns an array with all directions' do
        openings = a3_bishop.find_openings(board)
        answer = ['up_left', 'up_right', 'down_left', 'down_right']
        expect(openings).to eql(answer)
      end
    end
  end

  describe '#update_next_moves' do
    context 'When there are no valid moves' do
      it 'Returns an empty array' do
        bishop.update_next_moves(board)
        expect(bishop.next_moves).to eql([])
      end
    end

    context 'When there are valid moves up_right' do
      subject(:temp_board) { Board.new }
      before do
        # Remove the pawn diagonal to its up right
        temp_board.positions[1][3] = '-'
      end

      it 'Returns an array with valid moves' do
        bishop.update_next_moves(temp_board)
        answer = [[1, 3], [2, 4], [3, 5], [4, 6], [5, 7]]
        expect(bishop.next_moves).to eql(answer)
      end
    end

    context 'When there are valid moves up_left' do
      subject(:temp_board) { Board.new }
      before do
        # Block the vertical path
        temp_board.positions[1][1] = '-'
      end

      it 'Returns an array with valid moves' do
        bishop.update_next_moves(temp_board)
        # Answer is the entire rank except for bishop's place
        answer = [[1, 1], [2, 0]]
        expect(bishop.next_moves).to eql(answer)
      end
    end

    context 'When there are valid moves down_left' do
      subject(:temp_bishop) { described_class.new(3, 3)}

      it 'Returns an array with valid moves' do
        board.positions[2][4] = temp_bishop
        board.positions[4][4] = temp_bishop
        board.positions[4][2] = temp_bishop
        board.positions[3][3] = temp_bishop
        temp_bishop.update_next_moves(board)
        # Answer is the entire rank except for bishop's place
        answer = [[2, 2]]
        expect(temp_bishop.next_moves).to eql(answer)
      end
    end

    context 'When there are valid moves down_right' do
      subject(:temp_bishop) { described_class.new(5, 0) }

      it 'Returns an array with valid moves' do
        answer = [[6, 1], [4, 1], [3, 2], [2, 3]]
        temp_bishop.update_next_moves(board)
        expect(temp_bishop.next_moves).to eql(answer)
      end
    end

    context 'When there are valid moves on all sides' do
      subject(:temp_bishop) { WhiteBishop.new(3, 3)}

      it 'Returns an array with valid moves' do
        board.positions[3][3] = temp_bishop
        answer = [[4, 2], [5, 1], [6, 0], [4, 4], [5, 5], [6, 6], [2, 2], [2, 4]]
        temp_bishop.update_next_moves(board)
        expect(temp_bishop.next_moves).to eql(answer)
      end
    end
  end

  describe '#update_position' do
    context 'When you move bishops from A1 to A3' do
      before do
        allow(board).to receive(:puts)
      end

      it "Changes bishop's current position" do
        bishop.update_position(board, [2, 0], [0, 2])
        expect(bishop.current_position).to eql([2, 0])
      end

      it "Changes bishop's old position to empty" do
        bishop.update_position(board, [2, 0], [0, 0])
        old_position = board.positions[0][0]
        expect(old_position).to eql("-")
      end
    end
  end
end
