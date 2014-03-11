class Board
  attr_accessor :grid

  def initialize(grid=Array.new(8) {Array.new(8)})
    @grid = grid
  end

  #create factory method to generate pieces

  def inspect
    grid.each(&:puts)
  end

  def [](pos) #return error if position length != 2
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, piece) #return error if position length != 2
    x, y = pos
    @grid[x][y] = piece
  end

  def is_empty?(pos)
    self[pos] == nil
  end

  def in_grid?(pos)
    pos.all? {|coord| coord.between?(0, 7)}
  end
end