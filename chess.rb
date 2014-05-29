#!/usr/bin/env ruby

require "./piece"
require "./board"
require 'yaml'

class Chess
  attr_reader :board_game, :players, :current_player

  def initialize(board_game = nil, black_to_move = false)
    @board_game = board_game
    @board_game ||= Board.new.setup_board
    @players = [Human.new(:white, @board_game, self), Human.new(:light_black, @board_game, self)]
    @players.reverse! if black_to_move
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
  
  def save_game
    puts "name your game"
    name = gets.chomp
    name += ".rf"
    board = board_game.to_yaml
    f = File.new(name, "w")
    f.puts board
    f.puts "DIVIDE"
    f.puts current_player.color
    f.close
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
  attr_reader :game

  def initialize(color, game_board, game)
    @color = color
    @game_board = game_board
    @game = game
  end

  def get_turn
    input = gets.chomp
    if input == "save"
      game.save_game
      return nil
    end
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
  
  def initial_parse(command) #change from chess readable format
    
    dict = Board::LETTERS.invert
    string = ""
    command.chars.map! do |char|
      if /[A-H]/.match(char)
       string += (dict[char] - 1).to_s
     elsif /[1-8]/.match(char)
       num = (Integer(char) - 1)
       string += num.to_s
     else
       raise ArgumentError.new("I don't understand input.")
     end
    end
    string
  end

  def parse(command)
    command = initial_parse(command)
    
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

if __FILE__ == $PROGRAM_NAME
  puts "load saved game? (y/n)"
  answer = gets.chomp
  case answer
  when "y"
    game = nil
    until game
      puts "What is the name of your saved game?"
      name = gets.chomp + ".rf"
      if File.exist?(name)
        game = File.read(name)
         
      else
        puts "no such file"
      end
    end
    list = game.split("DIVIDE")
    board_game_string, color = list
    board_game = YAML::load(board_game_string)
    if color == "white"
      black_to_move = false
    else
      black_to_move = true
    end
    Chess.new(board_game, black_to_move).play
  when "n"
    Chess.new.play
  else
    "I dont understand"
  end
end