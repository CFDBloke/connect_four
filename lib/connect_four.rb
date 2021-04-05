# frozen_string_literal:true

# If testing with rspec, comment out lines 30, 85 amd 87 before hand

require_relative '../lib/rack'

# The class that exercises game control
class ConnectFour
  attr_accessor :rack

  def initialize
    @rack = Rack.new
  end

  def start
    puts <<-HERETO
           ***** WELCOME TO CONNECT 4 *****

    A game for two human players. Choose who is player 1 (red counter) and
    who is player 2 (yellow counter).  Take it in turns to place contours
    in the rack by selecting a column number to put your counter in.

    The first player to create a line of 4 of their counters wins. Winning
    lines can vertical, horizontal or diagonal.
    HERETO

    execute_game_play
  end

  private

  def execute_game_play
    until game_won?
      play_round(1)
      play_round(2) unless game_won?
    end

    game_end
  end

  def restart
    @rack = Rack.new
    execute_game_play
  end

  def game_end
    @rack.draw
    puts "Congratulations Player #{@rack.winner}, you've won!!"
    restart if play_again?
  end

  def play_round(player_number)
    @rack.draw

    play = @rack.place_piece(player_number, request_play(player_number))

    repeat_play(player_number, play) unless play == :play_complete
  end

  def request_play(player_number)
    puts "Player #{player_number}, please choose a column in which to place your piece"
    gets.chomp.to_i
  end

  def repeat_play(player_number, play)
    if play == :no_place
      puts "Sorry, there's no more space in that column, please select another...".colorize(31)
    else
      puts "Sorry, that column doesn't exist, please select one that does...".colorize(31)
    end
    puts "\n"
    play_round(player_number)
  end

  def game_won?
    @rack.winner != 0
  end

  def play_again?
    puts "Would you like to play again? ('y' for yes, anything else for no)"
    %w[y yes yeah].include?(gets.chomp.downcase)
  end
end

game = ConnectFour.new

game.start
