# frozen-string-literal: true

require './lib/board'
require './lib/player'
require './lib/computer'
require './lib/save'

# White has to move king if it is in check, else move piece normally
def white_move(white, black, board, save)
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

def black_move(white, black, board, save)
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

def put_intro
  puts "\e[1;35m
   ██████╗██╗  ██╗███████╗███████╗███████╗
  ██╔════╝██║  ██║██╔════╝██╔════╝██╔════╝
  ██║     ███████║█████╗  ███████╗███████╗
  ██║     ██╔══██║██╔══╝  ╚════██║╚════██║
  ╚██████╗██║  ██║███████╗███████║███████║
  ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝
  \e[0m"
  puts "\n\e[1;35mYou may save the game by entering \e[1;33m'save_game'\n\e[1;35minto the terminal anytime during the turns.\e[0m"
end

def choose_game_mode
  puts "\n\e[1;33mChoose a Gamemode: \n1: 2-Players\n2: Challenge the almighty 'DRUNK_maCPUrthy'\e[0m"

  game_mode = gets.chomp.to_i
  until game_mode == 1 || game_mode == 2
    game_mode = gets.chomp.to_i
  end

  game_mode
end

def player_pick_color
  puts "\n\e[1;33mPick a color!\n1: White\n2: Black\e[0m"
  color = gets.chomp.to_i
  until color == 1 || color == 2
    color = gets.chomp.to_i
  end
  color
end

put_intro
game_mode = choose_game_mode

board = Board.new
save = Save.new
# Make a saves directory
Dir.mkdir('saves') unless Dir.exist?('saves')

# Create player
case game_mode
# Two player mode
when 1
  white = Player.new('white')
  black = Player.new('black')

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

# Single player mode
when 2
  color = player_pick_color
  case color
  # White: player, Black: computer
  when 1
    white = Player.new('white')
    black = Computer.new('black')
  # White: player, Black: computer
  when 2
    white = Computer.new('white')
    black = Player.new('black')
  end

  # Ask player if they want to load a saved game
  # Load if yes
  save.load_game(board, white, black)
  board.update_all_pieces_next_moves
  board.print_board

  board.update_all_pieces_next_moves
  board.print_board

  # Loop until checkmate
  loop do
    white_move(white, black, board, save)
    black_move(white, black, board, save)
  end
end
