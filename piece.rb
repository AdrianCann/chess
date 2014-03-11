require "./board"

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
    board[position] = self
  end

  # helper methods

  def moves
    deltas = get_deltas # see if this calls the pieces own get_deltas
    pos_moves = deltas.map do |delta|
      [position.first + delta.first, position.last + delta.last]
    end.select do |coords|
      board.in_grid?(coords)
    end

    sel_legal_moves(pos_moves) # overide in slide/step subclass
  end

  def get_deltas
    KING.dup #default
  end

  def slope(coordinate)
    x, y = coordinate
    begin
      y/x
    rescue ZeroDivisionError => e
      :infinity
    end
  end
end

  # legal moves -- all unblocked moves?
    # sliding pieces paths are blocked by any piece in their path
    # stepping pieces are blocked by what's @ the end of their path

class SlidingPiece < Piece

  #rook
  def sel_legal_moves(poss_moves)
    occupied_coords = poss_moves.reject{|coord| board.is_empty?(coord)}
    occupied_coords.each do |occ_coord| # by a foreign piece

      # look at all possible moves in the same trajectory
      # selects the poss_moves ON THAT TRAJECTORY that are further from self than the piece  -- GREATER IN MAGNITUDE (use &:abs)
      illegal_moves = poss_moves.select do |pos_mov|
        occ_delta = [occ_coord.first - position.first, occ_cord.last - position.last]
        pos_delta = [pos_coord.first - position.first, pos_cord.last - position.last]

        slope(occ_delta) == slope(pos_delta)
      end.select do |pos_mov|
        occ_cord.first.abs <= pos_mov.first.abs
        occ_cord.last.abs <= pos_mov.last.abs
       end

      illegal_moves << shovel_that
    end

    poss_moves - illegal_moves
  end

end

class SteppingPiece < Piece

  def sel_legal_moves(poss_moves)
    poss_moves.select {|p_mov| board.is_empty?(p_mov)} # || enemy piece
  end

end

class Queen < SlidingPiece

  def get_deltas
    DIAGONALS.dup + ORTHOGONALS.dup
  end

  def inspect
    "#{color}Q"
  end

end

class Bishop < SlidingPiece

  def get_deltas
    DIAGONALS.dup
  end

  def inspect
    "#{color}B"
  end

end

class Rook < SlidingPiece

  def get_deltas
    ORTHOGONALS.dup
  end

  def inspect
    "#{color}R"
  end

end

class Knight < SteppingPiece

  def get_deltas
    L_SHAPED.dup
  end

  def inspect
    "#{color}N"
  end

end

class King < SteppingPiece

  def get_deltas
    KING.dup # default   # DRY later
  end

  def inspect
    "#{color}K"
  end

end