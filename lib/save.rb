# frozen-string-literal

require 'yaml'
require 'pry-byebug'

require './lib/board'
require './lib/player'
require './lib/pieces/rook'
require './lib/pieces/knight'
require './lib/pieces/bishop'
require './lib/pieces/queen'
require './lib/pieces/king'
require './lib/pieces/pawn'

# Mechanism for saving/loading game and storing data
class Save
  attr_accessor :data

  def initialize
    @data = {
      white_name: nil,
      black_name: nil,
      white_on_turn: nil,
      black_on_turn: nil,
      board: Array.new(8) { [] }
    }
  end

  # Save the game
  def save_game(board, white, black)
    save_name(white.name, black.name)
    save_on_turn(white.on_turn, black.on_turn)
    save_board(board)
    # Set up file naming system
    Dir.mkdir('saves') unless Dir.exist?('saves')
    filename = "#{@data[:white_name]}(W) vs #{@data[:black_name]}(B).yml"
    # Writing into the file
    File.open("saves/#{filename}", 'w') { |file| file.write(@data.to_yaml) }
  end

  # Load the game
  def load_game(board, white, black)
    return unless load_save?

    data = retrieve_saved_file
    return if data.nil?

    white.name = data[:white_name]
    black.name = data[:black_name]
    white.on_turn = data[:white_on_turn]
    black.on_turn = data[:black_on_turn]
    # data[:board] is an array starting from A1 to H7
    # Load each square on board with individual piece
    board.positions.map!.with_index do |rank, rank_index|
      rank.map!.with_index do |piece, index|
        piece = data[:board][rank_index][index]
      end
    end
  end

  # Return the saved_file in the form of a hash
  def retrieve_saved_file
    # Array of save files
    saves = Dir.entries('saves')
    # Remove the hidden files
    saves -= ['.', '..']
    if no_saves?(saves)
      puts "\n\e[1;31mThere are currently no save files."
      puts "Please continue with current game.\e[0m"
      return
    end
    filename = choose_save(saves)
    # Load the save
    YAML.load_file(
      "saves/#{filename}",
      aliases: true,
      permitted_classes: [
        WhiteRook,
        BlackRook,
        WhiteKnight,
        BlackKnight,
        WhiteBishop,
        BlackBishop,
        WhiteQueen,
        BlackQueen,
        WhiteKing,
        BlackKing,
        WhitePawn,
        BlackPawn,
        Symbol
      ]
    )
  end

  # Return true if there is no save files
  def no_saves?(saves)
    saves -= ['.', '..']
    return true if saves.empty?

    false
  end

  # Return true if player would like to load a game
  def load_save?
    puts "\nWould you like to load an old game? (Y/N)"
    reply = gets.chomp.upcase until %w[Y N].include?(reply)
    return false if reply == 'N'

    true
  end

  # Return the filename of selected save
  def choose_save(saves)
    # Ask player to choose a save file
    puts "\e[1;32m\nPlease choose a save file below: (eg. 1)"
    saves.each.with_index { |file_name, index| puts "\e[1;33m#{index + 1}: #{file_name}\e[0m" }
    index = 0
    index = gets.chomp.to_i until index.positive? && index <= saves.length
    saves[index - 1]
  end

  # Update @data[:name] with current player names
  def save_name(white_name, black_name)
    @data[:white_name] = white_name
    @data[:black_name] = black_name
  end

  # Update who is to continue after loading save
  def save_on_turn(white_on_turn, black_on_turn)
    @data[:white_on_turn] = white_on_turn
    @data[:black_on_turn] = black_on_turn
  end

  # Update @data[:board] with current board data
  def save_board(board)
    @data[:board]
    # From rank 1 to rank 8, push each square into snapshot
    board.positions.each.with_index do |rank, rank_index|
      rank.each do |piece|
        @data[:board][rank_index].push(piece)
      end
    end
  end
end
