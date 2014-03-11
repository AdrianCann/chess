#require "board"
# require "debugger"

class Piece

  DIAGONALS = [[1, 1], [-1, 1], [-1, -1], [1, -1]]

  ORTHOGONALS = [[0, 1], [0, -1], [1, 0], [-1, 0]]

  L_SHAPED = [[1, 2], [1, -2], [-1, -2], [-1, 2],
              [2, 1], [-2, 1], [-2, -1], [2, 1]]

  KING = [[1, 0], [-1, 0], [0, 1], [0, -1],
          [1, 1], [-1, -1],[1, -1],[-1, 1]]

  attr_accessor :position
  attr_reader :board, :color

  def initialize(position, color, board)
    @position, @color, @board = position, color, board
    board[position] = self
  end

  def is_enemy?(pos)
    return false if board[pos].nil?
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

class Pawn < Piece
  def moves
    the_moves = []
    case color
    when :W
      one_forward = [position.first - 1, position.last]
      two_forward = [position.first - 2, position.last]
      capture_left = [position.first - 1, position.last - 1]
      capture_right = [position.first - 1, position.last + 1]

      the_moves << one_forward
      the_moves <<  two_forward if position.first == 6
      the_moves <<  capture_left if board.in_grid?(capture_left) && is_enemy?(capture_left)
      the_moves <<  capture_right if board.in_grid?(capture_right) && is_enemy?(capture_right)

     # if position + [1,1] is_enemy? add move
      # if position + [-1,1] is_enemy? add move
    when :B
      one_forward = [position.first + 1, position.last]
      two_forward = [position.first + 2, position.last]
      capture_left = [position.first + 1, position.last + 1]
      capture_right = [position.first + 1, position.last - 1]


      the_moves << one_forward
      the_moves << two_forward if position.first == 1
      the_moves << capture_left if board.in_grid?(capture_left) && is_enemy?(capture_left)
      the_moves << capture_right if board.in_grid?(capture_right) && is_enemy?(capture_right)

      #fix case of it trying to capture off of the board...
    end
    the_moves
  end

  def inspect
    "#{color}P"
  end



end

#function to check color of other piece

#board.color_at?(pos)

class SteppingPiece < Piece

  def add_knight_moves
    knight_moves = []
    L_SHAPED.each do |l_mov|
      new_pos = [position.first + l_mov.first, position.last + l_mov.last]
      knight_moves << new_pos if board.in_grid?(new_pos) && (board.is_empty?(new_pos) || is_enemy?(new_pos))
    end
    knight_moves
  end

  def add_king_moves
    king_moves = []
    KING.each do |k_mov|
      new_pos = [position.first + k_mov.first, position.last + k_mov.last]
      king_moves << new_pos if board.in_grid?(new_pos) && (board.is_empty?(new_pos) || is_enemy?(new_pos))
    end
    king_moves
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

  def moves
    add_knight_moves
  end

  def inspect
    "#{color}N"
  end

end

class King < SteppingPiece

  def moves
    add_king_moves
  end

  def inspect
    "#{color}K"
  end

end