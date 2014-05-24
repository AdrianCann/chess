require "./colorize"

class Piece

  DIAGONALS = [[1, 1], [-1, 1], [-1, -1], [1, -1]]
  ORTHOGONALS = [[0, 1], [0, -1], [1, 0], [-1, 0]]

  attr_accessor :position
  attr_reader :board, :color

  def initialize(position, color, board)
    @position, @color, @board = position, color, board
    board[position] = self
  end

  def is_enemy?(pos)                    # for board?
    return false if board[pos].nil?
    board[pos].color != self.color
  end

  def move_into_check?(pos)
    new_board = self.board.deep_dup
    new_board.move!(self.position, pos)
    new_board.in_check?(self.color)
  end

  private
  def delta(dir, mod = 1)
    [position.first + (dir.first * mod), position.last + (dir.last * mod)]
  end
end

class Pawn < Piece
  PAWN_MOVES_W = [[-1, 0], [-2, 0], [-1, -1], [-1, 1]]
  PAWN_MOVES_B = [[1, 0], [2, 0], [1, 1], [1, -1]]

  def moves
    moves = []
    case color
    when :white
      moves = get_pawn_moves(PAWN_MOVES_W)
    when :light_black
      moves = get_pawn_moves(PAWN_MOVES_B)
    end
    moves
  end

  def inspect
    "P".colorize(color)
  end

  private
  def get_pawn_moves(mvs)  #delta takes an argument (always positive?)
    moves = []
    copy = mvs.dup
    copy.map!{ |dir| delta(dir) }.select!{|mv| board.in_grid?(mv) }

    moves << copy[0] if board.is_empty?(copy[0])
    if color == :light_black && position.first == 1 || color == :white && position.first == 6
      moves << copy[1] if board.is_empty?(copy[0]) && board.is_empty?(copy[1])
    end
    moves << copy[2] if is_enemy?(copy[2])
    moves << copy[3] if is_enemy?(copy[2])

    moves
  end
end

class SlidingPiece < Piece
  private
  def get_sliding_moves(directions)
    moves = []
    directions.each do |dir|
      i = 1
      new_pos = delta(dir)
      while board.in_grid?(new_pos)
        moves << new_pos if board.is_empty?(new_pos) || is_enemy?(new_pos)
        break unless board.is_empty?(new_pos)
        i += 1
        new_pos = delta(dir, i)
      end
    end

    moves
  end
end

class SteppingPiece < Piece
  private
  def get_stepping_moves(directions)
    moves = []
    directions.each do |dir|
      new_pos = delta(dir)
      if board.in_grid?(new_pos)
        moves << new_pos if board.is_empty?(new_pos) || is_enemy?(new_pos)
      end
    end

    moves
  end
end

class Queen < SlidingPiece

  def moves
    get_sliding_moves(DIAGONALS + ORTHOGONALS)
  end

  def inspect
    "Q".colorize(color)
  end

end

class Bishop < SlidingPiece

  def moves
    get_sliding_moves(DIAGONALS)
  end

  def inspect
    "B".colorize(color)
  end

end

class Rook < SlidingPiece

  def moves
    get_sliding_moves(ORTHOGONALS)
  end

  def inspect
    "R".colorize(color)
  end

end

class Knight < SteppingPiece

  L_SHAPED = [[1, 2], [1, -2], [-1, -2], [-1, 2],
              [2, 1], [-2, 1], [-2, -1], [2, 1]]

  def moves
    get_stepping_moves(L_SHAPED)
  end

  def inspect
    "N".colorize(color)
  end

end

class King < SteppingPiece

  def moves
    get_stepping_moves(ORTHOGONALS + DIAGONALS)
  end

  def inspect
    "K".colorize(color)
  end

end