# frozen-string-literal: true

require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'rook'

# Template and shared method for a Pawn
class Pawn
  attr_reader :symbol, :next_moves, :color
  attr_accessor :current_position, :en_passant_vulnerable

  def initialize(start_position, symbol, color)
    @symbol = symbol
    @color = color
    @en_passant_vulnerable = false
    @start_position = start_position
    @current_position = start_position
    @next_moves = []
  end

  # Test if space is empty to move to
  def empty_square?(board, rank, file)
    return false if rank > 7 || rank < 0 || file > 7 || file < 0 

    board.positions[rank][file] == '-'
  end

  # Test if space has an opponent piece
  def opponent_piece?(board, rank, file)
    return false if rank > 7 || rank < 0 || file > 7 || file < 0 

    return false if board.positions[rank][file] == '-'
    return true if board.positions[rank][file].color != @color
  end

  # Test if en_passant can be performed
  def en_passant_able?(board, rank, file)
    # Return false if it is an empty space
    return false if board.positions[rank][file] == '-'

    # Return false if it is not a pawn
    symbol = board.positions[rank][file].symbol
    return false unless symbol == '♙' || symbol == '♟︎'

    # Return false if it is our own pawn
    return false if symbol == @symbol

    # Return true if it is vulnerable to en_passant
    board.positions[rank][file].en_passant_vulnerable == true
  end

  # Return true if piece can be promoted
  def promote?
    rank = @current_position[0]
    return true if [0, 7].include?(rank)

    false
  end

  # Promote piece
  def promote_pawn(board, new_rank, new_file)
    board.print_board
    puts "\n\e[1;33mRook is up for promotion! Choose the desired piece: (1 ~ 4)
    1 - Queen
    2 - Rook
    3 - Bishop
    4 - Knight\e[0m"
    choice = gets.chomp.to_i
    until [1, 2, 3, 4].include?(choice)
      puts "\n\e[1;31mInvalid. Please enter a number: (1 ~ 4)\e[0m"
      choice = gets.chomp.to_i
    end

    # Promote white piece
    case new_rank
    when 7
      case choice
      when 1
        board.positions[new_rank][new_file] = WhiteQueen.new(new_rank, new_file)
      when 2
        board.positions[new_rank][new_file] = WhiteRook.new(new_rank, new_file)
      when 3
        board.positions[new_rank][new_file] = WhiteBishop.new(new_rank, new_file)
      when 4
        board.positions[new_rank][new_file] = WhiteKnight.new(new_rank, new_file)
      end
    # Promote black piece
    when 0
      case choice
      when 1
        board.positions[new_rank][new_file] = BlackQueen.new(new_rank, new_file)
      when 2
        board.positions[new_rank][new_file] = BlackRook.new(new_rank, new_file)
      when 3
        board.positions[new_rank][new_file] = BlackBishop.new(new_rank, new_file)
      when 4
        board.positions[new_rank][new_file] = BlackKnight.new(new_rank, new_file)
      end
    end
  end
end

# White Pawn
class WhitePawn < Pawn
  def initialize(rank, file)
    super([rank, file], '♟︎', 'white')
  end

  # Update piece location on board
  def update_position(board, new_position, old_position)
    new_rank = new_position[0]
    new_file = new_position[1]
    @current_position = new_position
    board.positions[new_rank][new_file] = self
    board.positions[old_position[0]][old_position[1]] = '-'

    # Promote
    promote_pawn(board, new_rank, new_file) if promote?

    # Toggle vulnerable if performed two jumps
    @en_passant_vulnerable = true if new_rank - old_position[0] == 2

    # Remove pawn that was en_passant-ed
    board.positions[new_rank - 1][new_file] = '-' if en_passant_able?(board, new_rank - 1, new_file)
    update_next_moves(board)
    board.print_board
  end

  # Updates @next_moves with current location
  def update_next_moves(board)
    @next_moves.clear
    rank = @current_position[0]
    file = @current_position[1]
    # One ahead
    @next_moves.push([rank + 1, file]) if empty_square?(board, rank + 1, file) || opponent_piece?(board, rank + 1, file)

    # Two ahead when yet to move
    if rank == 1 && empty_square?(board, rank + 1, file) && empty_square?(board, rank + 2, file)
      @next_moves.push([rank + 2, file])
    end

    # Check diagonal left
    @next_moves.push([rank + 1, file - 1]) if opponent_piece?(board, rank + 1, file - 1)

    # Check diagonal right
    @next_moves.push([rank + 1, file + 1]) if opponent_piece?(board, rank + 1, file + 1)

    # Check for en_passant opportunity on the right
    if empty_square?(board, rank + 1, file + 1) && en_passant_able?(board, rank, file + 1)
      @next_moves.push([rank + 1, file + 1])
    end

    # Check for en_passant opportunity on the left
    if empty_square?(board, rank + 1, file - 1) && en_passant_able?(board, rank, file - 1)
      @next_moves.push([rank + 1, file - 1])
    end
  end
end

# Black Pawn
class BlackPawn < Pawn
  def initialize(rank, file)
    super([rank, file], '♙', 'black')
  end

  # Update piece location on board
  def update_position(board, new_position, old_position)
    new_rank = new_position[0]
    new_file = new_position[1]
    @current_position = new_position
    board.positions[new_rank][new_file] = self
    board.positions[old_position[0]][old_position[1]] = '-'

    # Promote
    promote_pawn(board, new_rank, new_file) if promote?

    # Toggle vulnerable if performed two jumps
    @en_passant_vulnerable = true if old_position[0] - new_rank == 2

    # Remove pawn that was en_passant-ed
    board.positions[new_rank + 1][new_file] = '-' if en_passant_able?(board, new_rank + 1, new_file)
    update_next_moves(board)
    board.print_board
  end

  # Updates @next_moves with current location
  def update_next_moves(board)
    @next_moves.clear
    rank = @current_position[0]
    file = @current_position[1]
    # One down
    @next_moves.push([rank - 1, file]) if empty_square?(board, rank - 1, file) || opponent_piece?(board, rank - 1, file)

    # Two down when yet to move
    if rank == 6 && empty_square?(board, rank - 1, file) && empty_square?(board, rank - 2, file)
      @next_moves.push([rank - 2, file])
    end

    # Check diagonal down_left
    @next_moves.push([rank - 1, file - 1]) if opponent_piece?(board, rank - 1, file - 1)

    # Check diagonal down_right
    @next_moves.push([rank - 1, file + 1]) if opponent_piece?(board, rank - 1, file + 1)

    # Check for en_passant opportunity on the right
    if empty_square?(board, rank - 1, file + 1) && en_passant_able?(board, rank, file + 1)
      @next_moves.push([rank - 1, file + 1])
    end

    # Check for en_passant opportunity on the left
    if empty_square?(board, rank - 1, file - 1) && en_passant_able?(board, rank, file - 1)
      @next_moves.push([rank - 1, file - 1])
    end
  end
end
