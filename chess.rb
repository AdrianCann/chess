require "./piece"
require "./board"

class Chess
  attr_reader :board_game, :players, :current_player

  def initialize
    @board_game = Board.new
    @board_game.setup_board
    @players = [Human.new(:W, board_game), Human.new(:B, board_game)]
  end

  def play
    @current_player = players.first
    until over?

      board_game.render

      begin
        current_player.take_turn
      rescue IllegalMoveError => e
        puts ""
        puts "Illegal move. #{e.message} Please try again."
        board_game.render
        retry
      end

      @current_player = new_player
    end

    board_game.render
    puts "Checkmate."
  end

  def new_player
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

  def take_turn
    puts ""
    puts "Take turn, #{color.to_s} player:"

    input = gets.chomp
    coord_from, coord_to = parse(input)

    raise IllegalMoveError.new("That's not your piece!") if game_board[coord_from].color != color
    game_board.move(coord_from, coord_to)
  end

  def parse(command)
    # later: use regex to differentiate type of command
    # "1,2 3,4" <= default
    # "f2 a3"
    # misc notation

    # use regex to raise an error if nothing matches

    coordinate_pair = command.split(" ")        # "1,2 3,4" => ["1,2", "3,4"]
    coordinate_pair.map! do |coord|             # => "1,2"

      pars_coord = coord.split(",")             # "1,2" => ["1", "2"]
      pars_coord.map! { |coord| Integer(coord)} # ["1", "2"] => [1, 2]
      pars_coord.reverse                        # [1, 2] => [2, 1]
                                                # [[2,1], "3,4"]
    end

    coordinate_pair                              # [[2,1], [4,3]]
  end
end