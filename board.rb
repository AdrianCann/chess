class Board
  BOARD_WIDTH = 48

  attr_accessor :grid

  def initialize(grid=Array.new(8) {Array.new(8)})
    @grid = grid
  end

  def setup_board
    self[[0, 0]] = Rook.new([0, 0], :B, self)
    self[[0, 1]] = Knight.new([0, 1], :B, self)
    self[[0, 2]] = Bishop.new([0,2], :B, self)
    self[[0, 3]] = Queen.new([0,3], :B, self)
    self[[0, 4]] = King.new([0,4], :B, self)
    self[[0, 5]] = Bishop.new([0,5], :B, self)
    self[[0, 6]] = Knight.new([0, 6], :B, self)
    self[[0, 7]] = Rook.new([0, 7], :B, self)

    grid[1].count.times { |index| self[[1, index]] = Pawn.new([1,index], :B, self)}# make pawns

    self[[7, 0]] = Rook.new([7, 0], :W, self)
    self[[7, 1]] = Knight.new([7, 1], :W, self)
    self[[7, 2]] = Bishop.new([7,2], :W, self)
    self[[7, 3]] = Queen.new([7,3], :W, self)
    self[[7, 4]] = King.new([7,4], :W, self)
    self[[7, 5]] = Bishop.new([7,5], :W, self)
    self[[7, 6]] = Knight.new([7, 6], :W, self)
    self[[7, 7]] = Rook.new([7, 7], :W, self)


    grid[6].count.times { |index| self[[6, index]] = Pawn.new([6,index], :W, self)}# make pawns
  end

  def move(start_coord, end_coord)
    piece_to_move = self[start_coord]
    raise IllegalMoveError.new("No piece at that square!") if piece_to_move.nil?
    raise IllegalMoveError.new("Not a valid move!") unless piece_to_move.moves.include?(end_coord)

    raise IllegalMoveError.new("Your King is in Danger!") if piece_to_move.move_into_check?(end_coord) #piece_to_move.valid_move?(end_coord)

    self[start_coord], self[end_coord] = nil, piece_to_move
    piece_to_move.position = end_coord
  end

  def move!(start_coord, end_coord)
    piece_to_move = self[start_coord]
    raise IllegalMoveError.new("No piece at that square!") if piece_to_move.nil?
    raise IllegalMoveError.new("Not a valid move!") unless piece_to_move.moves.include?(end_coord)

    self[start_coord], self[end_coord] = nil, piece_to_move
    piece_to_move.position = end_coord
  end

  def render
    grid.each do |row|
      BOARD_WIDTH.times{print "-"}
      puts
      row.each do |tile|
        if tile.nil?
          print "|    |"
        else
          print "| #{tile.inspect} |"
        end
      end
      puts
    end
    BOARD_WIDTH.times{print "-"}

    nil
  end

  def in_check?(color)
    opposite_color = []
    king_position = []

    grid.each do |row|
      row.each do |piece|
        next if piece.nil?
        king_position = piece.position if piece.instance_of?(King) && piece.color == color
        opposite_color << piece if piece.color != color
      end
    end

    opposite_color.each do |enemy|
      return true if enemy.moves.include?(king_position)
    end

    false
  end

  def deep_dup
    new_board = Board.new
    grid.each do |row|
      row.each do |piece|
        next if piece.nil?
        piece_new = piece.class.new(piece.position.dup, piece.color, new_board)
        new_board[piece.position] = piece_new
      end
    end
    new_board
  end

  def [](pos) #return error if position length != 2
    x, y = pos # REMEMBER TO SWAP CO-ORDINATES IN PARSE COMMAND
    @grid[x][y]
  end

  def []=(pos, piece) #return error if position length != 2
    x, y = pos
    @grid[x][y] = piece
  end

  def is_empty?(pos)
    self[pos].nil?
  end

  def in_grid?(pos)
    pos.all? {|coord| coord.between?(0, 7)}
  end

  def color_at(pos)
    self[pos].color
  end
end

class IllegalMoveError < StandardError
end