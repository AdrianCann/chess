require "./piece"
require "./board"

class Chess
  attr_reader :board_game, :players, :current_player

  def initialize
    @board_game = Board.new # setup_board factory method
    @board_game.setup_board
    @players = [Human.new(:W, board_game), Human.new(:B, board_game)]
  end

  def play
    @current_player = players.first
    until over?
      board_game.render
      handle_turn
      @current_player = next_player
    end

    board_game.render
    puts "Checkmate."
  end

  private
  def handle_turn
    puts "Take turn, #{current_player.color} player:"

    begin # <= candidate for helper method
      current_player.get_turn
    rescue IllegalMoveError => e
      puts "Illegal move. #{e.message} Please try again."
      board_game.render
      retry
    rescue ArgumentError => e
      puts "#{e.message} Please try again."
      retry
    end
  end

  def next_player
    @current_player == players.last ? players.first : players.last
  end

  def over?
    players.any? { |player| board_game.checkmate?(player.color) }
  end
end

class Human
  attr_accessor :game_board
  attr_reader :color

  def initialize(color, game_board)
    @color = color
    @game_board = game_board
  end

  def get_turn
    input = gets.chomp
    coord_from, coord_to = parse(input)
    selected_piece = game_board[coord_from]

    handle_move_errors(selected_piece, coord_to)
    game_board.move(coord_from, coord_to)
  end

  private
  def handle_move_errors(selected_piece, end_coord)
    missing_piece = IllegalMoveError.new("No piece at that square!")
    enemy_piece = IllegalMoveError.new("That's not your piece!")
    invalid_move = IllegalMoveError.new("Not a valid move!")

    raise missing_piece if selected_piece.nil?
    raise enemy_piece unless selected_piece.color == color
    raise invalid_move unless selected_piece.moves.include?(end_coord)
  end

  def parse(command)
    digits = command.scan(/\d/) # scan for digits
    raise ArgumentError.new("I don't understand.") if digits.length < 4

    digits.map!{ |dig| Integer(dig) } # map digit chars to actual integers
    # return coordinate pair
    # => coordinate pair is in format [[inv(y), x], [inv(y), x]]
    [
      [ inv_y(digits[1]), digits[0] ],
      [ inv_y(digits[3]), digits[2] ]
    ]
  end

  def inv_y(int) # invert y - axis
    (int-7).abs
  end
end