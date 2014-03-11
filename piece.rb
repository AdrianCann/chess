class Piece
  attr_accessor :position
  attr_reader :board, :color

  def initialize(position, color, board)
    @position, @color, @board = position, color, board
  end

  def moves
  end

  def move_dirs
  end
end

