# frozen-string-literal: true

require 'pry-byebug'

require './lib/board'
require './lib/player'

puts "
██████╗██╗  ██╗███████╗███████╗███████╗
██╔════╝██║  ██║██╔════╝██╔════╝██╔════╝
██║     ███████║█████╗  ███████╗███████╗
██║     ██╔══██║██╔══╝  ╚════██║╚════██║
╚██████╗██║  ██║███████╗███████║███████║
 ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝
"
board = Board.new
white = Player.new('white')
black = Player.new('black')
board.update_all_pieces_next_moves
board.print_board

until black.win == true || white.win == true
  # White has to move king if it is in check, else move piece normally
  wk_position = board.king_position[:white]
  white_king = board.positions[wk_position[0]][wk_position[1]]
  white_king.in_check?(board) ? white.move_king_only(board, white, black) : white.move_piece(board)

  # If White wins
  break if white.win == true

  # Black has to move king if it is in check, else move piece normally
  bk_position = board.king_position[:black]
  black_king = board.positions[bk_position[0]][bk_position[1]]
  black_king.in_check?(board) ? black.move_king_only(board, black, white) : black.move_piece(board)
end
