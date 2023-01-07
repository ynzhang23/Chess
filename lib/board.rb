# frozen-string-literal: true

require 'pry-byebug'

require './lib/pieces/rook'
require './lib/pieces/knight'
require './lib/pieces/bishop'
require './lib/pieces/queen'
require './lib/pieces/king'
require './lib/pieces/pawn'

# Contains the win condition, constraints and board data
class Board
  attr_accessor :positions

  def initialize
    @positions = Array.new(8){ Array.new(8, '-')}
    place_all_pieces
    update_all_pieces_next_moves
  end

  def place_all_pieces
    place_all_rooks
    place_all_knights
    place_all_bishops
    place_all_queens
    place_all_kings
    place_all_pawns
    update_all_pieces_next_moves
  end

  # Updates next possible moves for all pieces
  def update_all_pieces_next_moves
    @positions.each do |row|
      row.each do |piece|
        next if piece == '-'
        piece.update_next_moves(self)
      end
    end
  end

  def place_all_rooks
    @positions[0][0] = WhiteRook.new(0, 0)
    @positions[0][7] = WhiteRook.new(0, 7)
    @positions[7][0] = BlackRook.new(7, 0)
    @positions[7][7] = BlackRook.new(7, 7)
  end

  def place_all_knights
    @positions[0][1] = WhiteKnight.new(0, 1)
    @positions[0][6] = WhiteKnight.new(0, 6)
    @positions[7][1] = BlackKnight.new(7, 1)
    @positions[7][6] = BlackKnight.new(7, 6)
  end

  def place_all_bishops
    @positions[0][2] = WhiteBishop.new(0, 2)
    @positions[0][5] = WhiteBishop.new(0, 5)
    @positions[7][2] = BlackBishop.new(7, 2)
    @positions[7][5] = BlackBishop.new(7, 5)
  end

  def place_all_queens
    @positions[0][3] = WhiteQueen.new(0, 3)
    @positions[7][3] = BlackQueen.new(7, 3)
  end

  def place_all_kings
    @positions[0][4] = WhiteKing.new(0, 4)
    @positions[7][4] = BlackKing.new(7, 4)
  end

  def place_all_pawns
    @positions[1].map!.with_index do |position, index|
      position = WhitePawn.new(1, index)
    end
    @positions[6].map!.with_index do |position, index|
      position = BlackPawn.new(6, index)
    end
  end

  def print_board
    rank_8 = filter_symbol(@positions[7]).join(' ')
    rank_7 = filter_symbol(@positions[6]).join(' ')
    rank_6 = filter_symbol(@positions[5]).join(' ')
    rank_5 = filter_symbol(@positions[4]).join(' ')
    rank_4 = filter_symbol(@positions[3]).join(' ')
    rank_3 = filter_symbol(@positions[2]).join(' ')
    rank_2 = filter_symbol(@positions[1]).join(' ')
    rank_1 = filter_symbol(@positions[0]).join(' ')

    puts "
    ⚉ A B C D E F G H ⚉
    8 #{rank_8} 8
    7 #{rank_7} 7
    6 #{rank_6} 6
    5 #{rank_5} 5
    4 #{rank_4} 4
    3 #{rank_3} 3
    2 #{rank_2} 2
    1 #{rank_1} 1
    ⚉ A B C D E F G H ⚉
    "
  end

  def filter_symbol(array)
    array.map do |position|
      if !position.is_a? String
        position.symbol
      else
        position
      end
    end
  end
end
