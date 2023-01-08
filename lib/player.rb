# frozen-string-literal: true

require 'pry-byebug'

require './lib/board'
require './lib/pieces/rook'

class Player
  # The valid notation for ranks
  RANK = ('a'..'h').to_a.concat(('A'..'H').to_a).freeze
  FILE = %w[1 2 3 4 5 6 7 8].freeze

  def initialize(color)
    @name = nil
    @player_color = color
    update_white_player_name if color == 'white'
    update_black_player_name if color == 'black'
  end

  def update_white_player_name
    puts 'White, please enter your name: '
    @name = gets.chomp
  end

  def update_black_player_name
    puts 'Black, please enter your name: '
    @name = gets.chomp
  end

  # Ask player for new location for selected piece and output resulting new board
  def move_piece(board)
    old_position = select_piece_to_move(board)
    new_position = ask_for_notation('move')
    selected_piece = board.positions[old_position[0]][old_position[1]]

    until move_allowed?(selected_piece, new_position)
      board.print_board
      puts "\n\e[1;31mMove is not allowed. Try again\e[0m"
      # start_position = select_piece_to_move(board)
      new_position = ask_for_notation('move')
      selected_piece = board.positions[old_position[0]][old_position[1]]
    end

    selected_piece.update_position(board, new_position, old_position)
  end

  # Confirm player's choice of piece to be moved and return position
  def select_piece_to_move(board)
    # Repeatedly ask player until valid notation is entered
    position = ask_for_notation('select')
    notation = position_to_notation(position)

    # Loop until selection is valid and verified by player
    until verified_selection?(board, position, notation)
      # Output error statements
      case selection_error(board, position)
      when 'empty'
        puts "\n\e[1;31m Chosen position is empty. Try again.\e[0m"
      when 'wrong color'
        puts "\n\e[1;31mChosen piece does not belong to you. Try again\e[0m"
      when 'no valid moves'
        puts "\n\e[1;31mChosen piece does not have any possible moves. Try again\e[0m"
      end

      board.print_board

      # Looped Actions
      position = ask_for_notation('select')
      notation = position_to_notation(position)
    end

    position
  end

  # Verify user selection
  def verified_selection?(board, position, notation)
    selected_piece = board.positions[position[0]][position[1]]
    return false if selected_piece == '-'
    return false unless selected_piece.color == @player_color
    return false if selected_piece.next_moves == []

    puts "\n\e[1;33m#{@name}, you have selected to move #{notation}'s #{selected_piece.symbol}.\e[1;0m"
    puts "\e[1;32mPress any key to continue.\e[1;0m"
    puts "\e[1;31mPress 'C' to reselect.\e[1;0m"

    response = $stdin.getch
    return false if %w[C c].include?(response)

    true
  end

  # Check if space selected contains a piece of player's color
  def selection_error(board, position)
    selected_space = board.positions[position[0]][position[1]]

    return 'empty' if selected_space == '-'
    return 'wrong color' unless selected_space.color == @player_color
    return 'no valid moves' if selected_space.next_moves == []

    true
  end

  # Repeat until player entered notation is correct, returns position array
  def ask_for_notation(action)
    puts "#{@name}, please select a piece to move (eg. A3): " if action == 'select'
    puts "#{@name}, where would you like to move the piece: " if action == 'move'
    # Ask for move until a valid chess notation is selected
    notation = gets.chomp
    until valid_notation?(notation)
      puts 'Invalid notation. Try again.'
      notation = gets.chomp
    end
    # Convert and return notation as position array
    notation = notation.split('')
    file = notation[0].downcase
    rank = notation[1]
    notation_to_position(file, rank)
  end

  # Check if entry is a valid chess notation
  def valid_notation?(notation)
    return false unless notation.length == 2

    array = notation.split('')
    return false unless Player::RANK.include?(array[0])
    return false unless Player::FILE.include?(array[1])

    true
  end

  # Convert notation to position array
  def notation_to_position(file, rank)
    position = []
    position.push((rank.to_i - 1))
    position.push((file.ord - 97))
  end

  # Convert position array to notation
  def position_to_notation(position)
    file = position[1]
    rank = position[0]
    (file + 97).chr.upcase + (rank + 1).to_s
  end

  # Check if move is allowed
  def move_allowed?(piece, new_position)
    valid_moves = piece.next_moves
    return true if valid_moves.include?(new_position)

    false
  end
end

board = Board.new
white = Player.new('white')
black = Player.new('black')
white.move_piece(board)
black.move_piece(board)
