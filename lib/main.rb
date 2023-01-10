# frozen-string-literal: true

require './lib/board'
require './lib/player'
require './lib/save'

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
save = Save.new
# Make a saves directory
Dir.mkdir('saves') unless Dir.exist?('saves')
save.load_game(board, white, black)
board.update_all_pieces_next_moves
board.print_board

loop do
  # If white saved the game
  if white.next_up == true
    white_move(white, board)
    black_move(black, board)
  end
  # If black saved the game
  black_move(black, board) if black.next_up == true

  # Loop
  white_move(white, board)
  black_move(black, board)
end

# White has to move king if it is in check, else move piece normally
def white_move(white, board)
  white.next_up = false
  wk_position = board.king_position[:white]
  white_king = board.positions[wk_position[0]][wk_position[1]]
  save_game = if white_king.in_check?(board)
                white.move_king_only(board, white, black)
              else
                white.move_piece(board)
              end
  # Save and exit the game if player inputs "save_game"
  if save_game == 'save_game'
    save.save_game(board, white, black)
    white.next_up = true
    exit
  end
end

def black_move(black, board)
  black.next_up = false
  # Black has to move king if it is in check, else move piece normally
  bk_position = board.king_position[:black]
  black_king = board.positions[bk_position[0]][bk_position[1]]
  save_game = if black_king.in_check?(board)
                black.move_king_only(board, black, white)
              else
                black.move_piece(board)
              end
  # Save and exit the game if player inputs "save_game"
  if save_game == 'save_game'
    save.save_game(board, white, black)
    black.next_up = true
    exit
  end
end
