require "board.rb"

class Piece

  DIAGONALS = [].tap do |diags|
    (-8..8).to_a.each do |coord|
      diags << [coord, coord]
      diags << [-coord, coord]
    end.delete([0, 0])
  end

  ORTHOGONALS = [].tap do |orths|
    (-8..8).to_a.each do |coord|
      orths << [coord, 0]
      orths << [0, coord]
    end.delete([0, 0])
  end

  # kill them with cleverness
  L_SHAPED = [1, -1, 2, -2].product([-2, 2, -1, 1]).select{|(x, y)| x.abs + y.abs == 3}

  KING = [1, 0, -1].product([1, 0, -1]).delete([0, 0])

  attr_accessor :position
  attr_reader :board, :color

  def initialize(position, color, board)
    @position, @color, @board = position, color, board
  end

  # helper methods

  def moves
    #get deltas sums up all deltas for a sublcass
    pos_moves = deltas.map do |delta|
      [position.first + delta.first, position.last + delta.last]
    end.select do |coords|
      board.in_grid?(coords)
    end

    sel_legal_moves(pos_moves) # overide in slide/step subclass

    # select legal_moves and return as array
    # legal moves -- all unblocked moves?
      # sliding pieces paths are blocked by any piece in their path
      # stepping pieces are blocked by what's @ the end of their path
  end
end

class SlidingPiece < Piece

  def select_legal_moves(poss_moves)
    # select all legal moves from poss_moves (based on @board) and return array of positions
  end

end

class SteppingPiece < Piece




  def select_legal_moves(poss_moves)
    # select all legal moves from poss_moves (based on @board) and return array of positions
  end

end

class Queen < SlidingPiece
  DIAGONALS && ORTHOGONALS
end

class Bishop < SlidingPiece
  DIAGONALS
end

class Rook < SlidingPiece
  ORTHOGONALS
end

class Knight < SteppingPiece
  L-SHAPED
end

class King < SteppingPiece
  KING
end




=begin

DIAGONALS

ORTHOGONALS

L-SHAPED

KING


diagonals

[1,1], [2,2], [3,3] ... [8,8]
[1, -1] ... [8, -8]
...

possible moves << coord + delta



=end