require "./board"

class Piece

  DIAGONALS = [[1, 1], [-1, 1], [-1, -1], [1, -1]]

  ORTHOGONALS = [[0, 1], [0, -1], [1, 0], [-1, 0]]

  L_SHAPED = [[1, 2], [1, -2], [-1, -2], [-1, 2],
              [2, 1], [-2, 1], [-2, -1], [2, 1]]

  # KING = [1, 0, -1].product([1, 0, -1]).delete([0, 0])

  attr_accessor :position
  attr_reader :board, :color

  def initialize(position, color, board)
    @position, @color, @board = position, color, board
    board[position] = self
  end

  # helper methods

  def moves

  end

end


class SlidingPiece < Piece


  def sel_legal_moves(poss_moves)

  end

end

class SteppingPiece < Piece

  def sel_legal_moves(poss_moves)

  end

end

class Queen < SlidingPiece

  def inspect
    "#{color}Q"
  end

end

class Bishop < SlidingPiece

  def inspect
    "#{color}B"
  end

end

class Rook < SlidingPiece

  def inspect
    "#{color}R"
  end

end

class Knight < SteppingPiece

  def inspect
    "#{color}N"
  end

end

class King < SteppingPiece

  def inspect
    "#{color}K"
  end

end