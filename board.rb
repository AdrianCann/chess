class Board
  BOARD_WIDTH = 40

  attr_accessor :grid

  def initialize(grid=Array.new(8) {Array.new(8)})
    @grid = grid
  end

  def setup_board
    place_side(0, 1, :light_black)
    place_side(7, 6, :white)

    self
  end

  def place_side(row, pawn_row, color)
    back_row_pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    grid.length.times do |i|
      self[[row, i]] = back_row_pieces[i].new([row, i], color, self)
      self[[pawn_row, i]] = Pawn.new([pawn_row, i], color, self)
    end

    nil # side effect method
  end

  def move(start_coord, end_coord)
    king_in_danger = IllegalMoveError.new("Your King is in Danger!")
    raise king_in_danger if self[start_coord].move_into_check?(end_coord)

    move!(start_coord, end_coord)
  end

  def move!(start_coord, end_coord)
    selected_piece = self[start_coord]

    self[start_coord], self[end_coord] = nil, selected_piece
    selected_piece.position = end_coord
  end

  def checkmate?(color)
    if in_check?(color)
      all_pieces_of_color(color) do |pc|
        pc.moves.each{ |move| return false unless pc.move_into_check?(move)}
      end
      return true
    end

    false
  end

  def render
    grid.each_with_index do |row, num|

      print "  "; BOARD_WIDTH.times{print "-"}; puts ""
      print "#{(num-7).abs} "

      row.each do |tile|
        if tile.nil?
          print "|   |"
        else
          print "| #{tile.inspect} |"
        end
      end
      puts ""
    end

    # print bottom numbers
    print "  "; BOARD_WIDTH.times{ print "-"}; puts ""
    print "  "; grid.length.times{ |i| print "  #{i}  "}; puts ""

    nil
  end

  def in_check?(color)
    king_pos = []
    all_pieces_of_color(color) do |pc|
      king_pos = pc.position if pc.instance_of?(King)
    end

    opp_color = []
    all_pieces_not_of_color(color){|pc| opp_color << pc}
    opp_color.each{|enemy| return true if enemy.moves.include?(king_pos)}

    false
  end

  def deep_dup
    new_board = Board.new

    all_pieces do |pc|
      piece_new = pc.class.new(pc.position.dup, pc.color, new_board)
      new_board[pc.position] = piece_new
    end
    new_board
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, piece)
    x, y = pos
    @grid[x][y] = piece
  end

  def is_empty?(pos)
    self[pos].nil?
  end

  def in_grid?(pos)
    pos.all? {|coord| coord.between?(0, 7)}
  end

  private
  def all_pieces_of_color(color, &block)
    all_pieces { |piece| block.call(piece) if piece.color == color}
  end

  def all_pieces_not_of_color(color, &block)
    all_pieces { |piece| block.call(piece) unless piece.color == color}
  end

  def all_pieces(&block)
    grid.each do |row|
      row.each do |piece|
        next if piece.nil?
        block.call(piece)
      end
    end
  end
end

class IllegalMoveError < StandardError
end