# frozen-string-literal: true

require './lib/board'
require './lib/player'
require './lib/save'

# White has to move king if it is in check, else move piece normally
def self.white_move(white, black, board, save)
  white.on_turn = false
  wk_position = board.king_position[:white]
  white_king = board.positions[wk_position[0]][wk_position[1]]
  save_game = if white_king.in_check?(board)
                white.move_king_only(board, white, black)
              else
                white.move_piece(board)
              end
  # Save and exit the game if player inputs "save_game"
  if save_game == 'save_game'
    white.on_turn = true
    save.save_game(board, white, black)
    exit
  end
end

def self.black_move(white, black, board, save)
  black.on_turn = false
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
    black.on_turn = true
    save.save_game(board, white, black)
    exit
  end
end

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

# Ask player if they want to load a saved game
# Load if yes
save.load_game(board, white, black)
board.update_all_pieces_next_moves
board.print_board

# Loop until checkmate
loop do
  # If white saved the game, resume with white
  if white.on_turn == true
    white_move(white, black, board, save)
    black_move(white, black, board, save)
  end
  # If black saved the game, resume with black
  black_move(white, black, board, save) if black.on_turn == true

  # Loop
  white_move(white, black, board, save)
  black_move(white, black, board, save)
end
