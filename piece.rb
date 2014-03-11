#require "board"
# require "debugger"

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

  def is_enemy?(pos)
    board[pos].color != self.color
  end

  # helper methods

  # move(to_position)
end


class SlidingPiece < Piece

  def add_diagonal_moves
    # debugger
    diagonal_moves = []
    DIAGONALS.each do |diag|
      i = 1
      new_pos = [(position.first + (diag.first * i)), (position.last + (diag.last * i))]
      while board.in_grid?(new_pos)
        if board.is_empty?(new_pos)
          diagonal_moves << new_pos
        elsif is_enemy?(new_pos)
          diagonal_moves << new_pos
          break
        else
          break
        end
        i += 1
        new_pos = [position.first + (diag.first * i), position.last + (diag.last * i)]
      end
    end
    diagonal_moves
  end

  def add_orthogonal_moves
    orthogonal_moves = []
    ORTHOGONALS.each do |orth|
      i = 1
      new_pos = [position.first + (orth.first * i), position.last + (orth.last * i)]
      while board.in_grid?(new_pos)
        if board.is_empty?(new_pos)
          orthogonal_moves << new_pos
        elsif is_enemy?(new_pos)
          orthogonal_moves << new_pos
          break
        else
          break
        end
        i += 1
        new_pos = [position.first + (orth.first * i), position.last + (orth.last * i)]
      end
    end
    orthogonal_moves
  end
end

#function to check color of other piece

#board.color_at?(pos)

class SteppingPiece < Piece

  def add_knight_moves
    knight_moves = []
    L_MOVES.each do |l_mov|
      new_pos = [position.first + l_mov.first, position.last + l_mov.last]
      knight_moves << new_pos if board.in_grid?(new_pos) && (board.is_empty?(new_pos) || is_enemy?(new_pos))
    end
    knight_moves
  end

end

class Queen < SlidingPiece

  def moves
    add_diagonal_moves + add_orthogonal_moves
  end

  def inspect
    "#{color}Q"
  end

end

class Bishop < SlidingPiece

  def moves
    add_diagonal_moves
  end

  def inspect
    "#{color}B"
  end

end

class Rook < SlidingPiece

  def moves
    add_orthogonal_moves
  end

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