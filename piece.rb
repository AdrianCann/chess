require "board.rb"

class Piece
  attr_accessor :position
  attr_reader :board, :color

  def initialize(position, color, board)
    @position, @color, @board = position, color, board
  end

  def moves
    # will require piece's position & board

    # call move_dirs || delta depending if it's sliding
    # or stepping => array of all possible moves
      # possible moves -- all moves in board

    # select legal_moves and return as array
    # legal moves -- all unblocked moves?
      # sliding pieces paths are blocked by any piece in their path
      # stepping pieces are blocked by what's @ the end of their path
  end

  def move_dirs

    # add orthgonal
      # based on position, add all orthogonal co-ordinates to arr_to_return

    # add diagonal
      # based on position, add all diagonal co-ordinates to arr_to_return

  end

  def delta_dirs

    # deltas = [... some moves ...]

    # each delta, add to pos and push result to arr_to_return

  end

  def select_legal_moves(poss_moves)
    # select all legal moves from poss_moves and return array of positions
  end
end

