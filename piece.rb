class Piece

  DIAGONALS = [[1, 1], [-1, 1], [-1, -1], [1, -1]]

  ORTHOGONALS = [[0, 1], [0, -1], [1, 0], [-1, 0]]

  L_SHAPED = [[1, 2], [1, -2], [-1, -2], [-1, 2],
              [2, 1], [-2, 1], [-2, -1], [2, 1]]

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
end

class SlidingPiece < Piece
  def get_sliding_moves(directions)
    moves = []
    directions.each do |dir|
      i = 1
      new_pos = [position.first + dir.first, position.last + dir.last]
      while board.in_grid?(new_pos)
        moves << new_pos if board.is_empty?(new_pos) || is_enemy?(new_pos)
        break unless board.is_empty?(new_pos)
        i += 1
        new_pos = [position.first + (dir.first * i), position.last + (dir.last * i)]
      end
    end

    moves
  end
end

class Pawn < Piece
  PAWN_MOVES_W = [[-1, 0], [-2, 0], [-1, -1], [-1, 1]]
  PAWN_MOVES_B = [[1, 0], [2, 0], [1, 1], [1, -1]]

  def moves
    moves = []
    case color
    when :W
      moves = get_pawn_moves(PAWN_MOVES_W)

      # one_forward = [position.first - 1, position.last]
 #      two_forward = [position.first - 2, position.last]
 #      capture_left = [position.first - 1, position.last - 1]
 #      capture_right = [position.first - 1, position.last + 1]
 #
 #      the_moves << one_forward if board.is_empty?(one_forward)
 #      the_moves << two_forward if position.first == 6 && (board.is_empty?(one_forward) && board.is_empty?(two_forward))
 #      the_moves << capture_left if board.in_grid?(capture_left) && is_enemy?(capture_left)
 #      the_moves << capture_right if board.in_grid?(capture_right) && is_enemy?(capture_right)

    when :B
      moves = get_pawn_moves(PAWN_MOVES_B)

      # one_forward = [position.first + 1, position.last]
      # two_forward = [position.first + 2, position.last]
      # capture_left = [position.first + 1, position.last + 1]
      # capture_right = [position.first + 1, position.last - 1]
      #
      # the_moves << one_forward if board.is_empty?(one_forward)
      # the_moves << two_forward if position.first == 1 && (board.is_empty?(one_forward) && board.is_empty?(two_forward))
      # the_moves << capture_left if board.in_grid?(capture_left) && is_enemy?(capture_left)
      # the_moves << capture_right if board.in_grid?(capture_right) && is_enemy?(capture_right)
    end
    the_moves
  end

  def inspect
    "#{color}P"
  end

end

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
    (DIAGONALS + ORTHOGONALS).each do |k_mov|
      new_pos = [position.first + k_mov.first, position.last + k_mov.last]
      king_moves << new_pos if board.in_grid?(new_pos) && (board.is_empty?(new_pos) || is_enemy?(new_pos))
    end
    king_moves
  end
end

class Queen < SlidingPiece

  def moves
    get_sliding_moves(DIAGONALS + ORTHOGONALS)
  end

  def inspect
    "#{color}Q"
  end

end

class Bishop < SlidingPiece

  def moves
    get_sliding_moves(DIAGONALS)
  end

  def inspect
    "#{color}B"
  end

end

class Rook < SlidingPiece

  def moves
    get_sliding_moves(ORTHOGONALS)
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