# frozen-string-literal: true

require './lib/pieces/king'
require './lib/board'

describe Board do
  subject(:board) { Board.new }

  describe '#update_all_pieces_next_moves' do
    context 'When two Kings are one square away from each other' do
      it 'Updates white king next steps correctly' do
        board.positions[3][3] = WhiteKing.new(3, 3)
        board.positions[3][5] = BlackKing.new(3, 5)
        board.positions[0][4] = '-'
        board.positions[7][4] = '-'
        board.update_all_pieces_next_moves
        answer = [[2, 3], [3, 2], [2, 2]]
        white_next_moves = board.positions[3][3].next_moves
        expect(white_next_moves).to eql(answer)
      end

      it 'Updates black king next steps correctly' do
        board.positions[3][3] = WhiteKing.new(3, 3)
        board.positions[3][5] = BlackKing.new(3, 5)
        board.positions[0][4] = '-'
        board.positions[7][4] = '-'
        board.update_all_pieces_next_moves

        answer = [[4, 5], [4, 6]]
        black_next_moves = board.positions[3][5].next_moves

        expect(black_next_moves).to eql(answer)
      end
    end

    context 'When the square right of white king is attacked' do
      it 'Square is not in white king next steps' do
        board.positions[3][3] = WhiteKing.new(3, 3)
        board.positions[5][4] = BlackRook.new(5, 4)
        board.positions[0][4] = '-'
        board.update_all_pieces_next_moves
        answer = [[2, 3], [3, 2], [2, 2]]
        white_next_moves = board.positions[3][3].next_moves
        expect(white_next_moves).to eql(answer)
      end
    end
  end
end