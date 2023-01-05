# frozen-string-literal: true

# Contains the win condition, constraints and board data

class Board
  def initialize
    @positions = Array.new(8){ Array.new(8, '-')}
  end

  def print_board
    rank_8 = @positions[7].join(' ')
    rank_7 = @positions[6].join(' ')
    rank_6 = @positions[5].join(' ')
    rank_5 = @positions[4].join(' ')
    rank_4 = @positions[3].join(' ')
    rank_3 = @positions[2].join(' ')
    rank_2 = @positions[1].join(' ')
    rank_1 = @positions[0].join(' ')
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
end
