# frozen-string-literal: true

# Template and shared method for a King
class King
  attr_reader :symbol, :next_moves, :color
  attr_accessor :current_position, :moved

  def initialize(start_position, symbol, color)
    @symbol = symbol
    @color = color
    @start_position = start_position
    @current_position = start_position
    @next_moves = []
    @moved = false
  end

  # Update piece location on board
  def update_position(board, new_position, old_position)
    @current_position = new_position
    new_rank = new_position[0]
    new_file = new_position[1]
    old_rank = old_position[0]
    old_file = old_position[1]

    board.positions[new_rank][new_file] = self
    board.positions[old_rank][old_file] = '-'

    # If King castled to the left
    if old_file - new_file == 2
      # Move the left rook over the king
      left_rook = board.positions[new_rank][0]
      board.positions[new_rank][new_file + 1] = left_rook
      board.positions[new_rank][0] = '-'
    end

    # If King castled to the right
    if new_file - old_file == 2
      # Move the right rook over the king
      right_rook = board.positions[new_rank][7]
      board.positions[new_rank][new_file - 1] = right_rook
      board.positions[new_rank][7] = '-'
    end
    board.print_board
    update_next_moves(board)
    @moved = true
  end

  # Return true if King is in check
  def in_check?(board)
    return true if attacked_squares(board).include?(@current_position)
    false
  end

  # Updates @next_moves with current location
  def update_next_moves(board)
    @next_moves.clear

    rank = @current_position[0]
    file = @current_position[1]
    # Up
    @next_moves.push([rank + 1, file]) if valid_move?(board, rank + 1, file)
    # Down
    @next_moves.push([rank - 1, file]) if valid_move?(board, rank - 1, file)
    # Left
    @next_moves.push([rank, file - 1]) if valid_move?(board, rank, file - 1)
    # Right
    @next_moves.push([rank, file + 1]) if valid_move?(board, rank, file + 1)
    # Up Left
    @next_moves.push([rank + 1, file - 1]) if valid_move?(board, rank + 1, file - 1)
    # Up Right
    @next_moves.push([rank + 1, file + 1]) if valid_move?(board, rank + 1, file + 1)
    # Down Left
    @next_moves.push([rank - 1, file - 1]) if valid_move?(board, rank - 1, file - 1)
    # Down Right
    @next_moves.push([rank - 1, file + 1]) if valid_move?(board, rank - 1, file + 1)
    # Left Castling
    @next_moves.push([rank, file - 2]) if left_castling_available?(board)
    # Right Castling
    @next_moves.push([rank, file + 2]) if right_castling_available?(board)
    # Remove moves that will result the King to be checked
    @next_moves -= attacked_squares(board)

    # Remove moves that will result the King to be checked by opponent King
    @next_moves -= opponent_king_adjacent(board)
  end

  # Test if space is valid to move to
  def valid_move?(board, rank, file)
    return false if rank.negative? || rank > 7 || file.negative? || file > 7
    return true if board.positions[rank][file] == '-'
    return false if board.positions[rank][file].color == @color

    true
  end

  # Return an array of squares attacked by the opponent pieces
  def attacked_squares(board)
    attacked_squares = []
    board.positions.each do |row|
      row.each do |piece|
        next if piece == '-'
        next if piece.color == @color

        attacked_squares += piece.next_moves
        # Take into account of pawn's diagonal square
        case piece.symbol
        when '♙'
          rank = piece.current_position[0]
          file = piece.current_position[1]
          array = [[rank + 1, file - 1], [rank + 1, file + 1]]
          attacked_squares += array
        when '♟︎'
          rank = piece.current_position[0]
          file = piece.current_position[1]
          array = [[rank - 1, file - 1], [rank - 1, file + 1]]
          attacked_squares += array
        end
      end
    end
    attacked_squares.uniq
  end

  # Return an array of adjacent squares of the opponent king
  def opponent_king_adjacent(board)
    adjacent_squares = []
    case @color
    when 'white'
      rank = board.king_position[:black][0]
      file = board.king_position[:black][1]
    when 'black'
      rank = board.king_position[:white][0]
      file = board.king_position[:white][1]
    end
    # Up
    adjacent_squares.push([rank + 1, file]) if opp_king_valid_move?(board, rank + 1, file)
    # Down
    adjacent_squares.push([rank - 1, file]) if opp_king_valid_move?(board, rank - 1, file)
    # Left
    adjacent_squares.push([rank, file - 1]) if opp_king_valid_move?(board, rank, file - 1)
    # Right
    adjacent_squares.push([rank, file + 1]) if opp_king_valid_move?(board, rank, file + 1)
    # Up Left
    adjacent_squares.push([rank + 1, file - 1]) if opp_king_valid_move?(board, rank + 1, file - 1)
    # Up Right
    adjacent_squares.push([rank + 1, file + 1]) if opp_king_valid_move?(board, rank + 1, file + 1)
    # Down Left
    adjacent_squares.push([rank - 1, file - 1]) if opp_king_valid_move?(board, rank - 1, file - 1)
    # Down Right
    adjacent_squares.push([rank - 1, file + 1]) if opp_king_valid_move?(board, rank - 1, file + 1)

    adjacent_squares
  end

  def opp_king_valid_move?(board, rank, file)
    return false if rank.negative? || rank > 7 || file.negative? || file > 7
    return true if board.positions[rank][file] == '-'
    # Valid move if adj. piece is opposite color
    return true if board.positions[rank][file].color == @color

    # Return false since adj. piece is own color
    false
  end
end

# White King
class WhiteKing < King
  def initialize(rank, file)
    super([rank, file], '♔', 'white')
  end

  def left_castling_available?(board)
    # Check if King has not moved
    return false if @moved == true
    # Check if Rook has not moved
    return false if board.positions[0][0] == '-'
    return false unless board.positions[0][0].symbol == '♖'
    return false if board.positions[0][0].moved == true

    # Check if path is clear
    (1..3).each do |num|
      return false unless board.positions[0][num] == '-'
    end

    # Check if no opponent piece can move to square moved over by King
    square_moved_over = [0, 3]
    square_to_land = [0, 2]
    board.positions.each do |row|
      row.each do |piece|
        next if piece == '-'
        next if piece.color == @color
        return false if (piece.next_moves & [square_moved_over, square_to_land]).any?
      end
    end

    true
  end

  def right_castling_available?(board)
    # Check if King has not moved
    return false if @moved == true
    # Check if Rook has not moved
    return false if board.positions[0][7] == '-'
    return false unless board.positions[0][7].symbol == '♖'
    return false if board.positions[0][7].moved == true

    # Check if path is clear
    (5..6).each do |num|
      return false unless board.positions[0][num] == '-'
    end

    # Check if no opponent piece can move to square moved over by King
    square_moved_over = [0, 5]
    square_to_land = [0, 6]
    board.positions.each do |row|
      row.each do |piece|
        next if piece == '-'
        next if piece.color == @color
        return false if (piece.next_moves & [square_moved_over, square_to_land]).any?
      end
    end

    true
  end
end

# Black King
class BlackKing < King
  def initialize(rank, file)
    super([rank, file], '♚', 'black')
  end

  def left_castling_available?(board)
    # Check if King has not moved
    return false if @moved == true

    # Check if Rook has not moved
    return false if board.positions[7][0] == '-'
    return false unless board.positions[7][0].symbol == '♜'
    return false if board.positions[7][0].moved == true

    # Check if path is clear
    (1..3).each do |num|
      return false unless board.positions[7][num] == '-'
    end

    # Check if no opponent piece can move to square moved over by King
    square_moved_over = [7, 3]
    square_to_land = [7, 2]
    board.positions.each do |row|
      row.each do |piece|
        next if piece == '-'
        next if piece.color == @color
        return false if (piece.next_moves & [square_moved_over, square_to_land]).any?
      end
    end

    true
  end

  def right_castling_available?(board)
    # Check if King has not moved
    return false if @moved == true

    # Check if Rook has not moved
    return false if board.positions[7][7] == '-'
    return false unless board.positions[7][7].symbol == '♜'
    return false if board.positions[7][7].moved == true

    # Check if path is clear
    (5..6).each do |num|
      return false unless board.positions[7][num] == '-'
    end

    # Check if no opponent piece can move to square moved over by King
    square_moved_over = [7, 5]
    square_to_land = [7, 6]
    board.positions.each do |row|
      row.each do |piece|
        next if piece == '-'
        next if piece.color == @color
        return false if (piece.next_moves & [square_moved_over, square_to_land]).any?
      end
    end

    true
  end
end
