# frozen-string-literal: true

require './lib/board'
require './lib/save'

# Method calls for a computer player
class Computer
  attr_accessor :win, :name, :on_turn

  def initialize(color)
    @name = 'DRUNK_maCPUrthy'
    @player_color = color
    @win = false
    @on_turn = false
  end

  def move_piece(board)
    refresh_pawn(board)

    # Select one random piece
    available_pieces = []
    board.positions.each do |row|
      row.each do |el|
        next if el == '-'
        next unless el.color == @player_color
        next if el.next_moves.empty?

        available_pieces.push(el.current_position)
      end
    end
    selected_square = available_pieces.sample
    selected_piece = board.positions[selected_square[0]][selected_square[1]]

    # Select one random next move
    new_position = selected_piece.next_moves.sample

    # Move the piece
    selected_piece.update_position(board, new_position, selected_piece.current_position)

    # Refresh every piece's possible next_moves
    board.update_all_pieces_next_moves
  end

  def move_king_only(board, _black, _white)
    rank = board.king_position[@player_color.to_sym][0]
    file = board.king_position[@player_color.to_sym][1]
    king = board.positions[rank][file]
    # Randomly choose a position to move king towards
    new_position = king.next_moves.sample
    king.update_position(board, new_position, king.current_position)

    # Refresh every piece's possible next_moves
    board.update_all_pieces_next_moves
  end

  # Remove player's own pawns en_passant vulnerability at the start of his turn
  def refresh_pawn(board)
    board.positions.each do |row|
      row.each do |piece|
        next if piece == '-'
        next unless piece.color == @player_color
        next unless piece.symbol == '♟︎' || piece.symbol == '♙'

        piece.en_passant_vulnerable = false
      end
    end
  end
end
