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
    board.positions[new_position[0]][new_position[1]] = self
    board.positions[old_position[0]][old_position[1]] = '-'
    update_next_moves(board)
    board.print_board
    @moved = true
  end

  # Updates @next_moves with current location
  def update_next_moves(board)
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
  end

  # Test if space is valid to move to
  def valid_move?(board, rank, file)
    return false if rank.negative? || rank > 7 || file.negative? || file > 7
    return true if board.positions[rank][file] == '-'
    return false if board.positions[rank][file].color == @color

    true
  end
end

# White King
class WhiteKing < King
  def initialize(rank, file)
    super([rank, file], '♚', 'white')
  end

  def left_castling_available?(board)
    # Check if King has not moved
    return false if @moved == true
    # Check if Rook has not moved
    return false if board.positions[0][0] == '-'
    return false unless board.positions[0][0].symbol == '♜'
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
    return false unless board.positions[0][7].symbol == '♜'
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
    super([rank, file], '♔', 'black')
  end
end
