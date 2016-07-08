$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require 'board'
require 'player'
require 'computer_player'
require 'ship'
require 'colorize'

class BattleshipGame
  attr_accessor :player1, :player2, :current_player, :ships, :game_choice

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @current_player = @player1
    choose_game
  end

  def choose_game
    @game_choice = choose_game_output
    if @game_choice == 'S'
      set_up_game
    elsif is_game_advanced?
      @ships = Ship.new(@player1, @player2, self)
      @ships.set_up_ships
    else
      goodbye_output
    end
  end

  def set_up_game
    clear
    welcome_output
    input = @current_player.get_setup
    if input == 0
      default_game_set_up
    else
      custom_game_set_up(input)
    end
    play
  end

  def attack(pos)
    x, y = pos[0], pos[1]
    if @current_player.board.is_move_valid?(x, y)
      if ship_hit?(x, y)
        count_before = @current_player.board.advanced_count
        @current_player.board.remove_from_ships(x, y) if is_game_advanced?
        clear
        if count_before > @current_player.board.advanced_count
          ship_sunk!(pos)
        else
          ship_hit!(pos)
        end
      else
        no_ships_hit(x, y)
      end
      return true
    else
      return false # move not valid
    end
  end

  def count
    if is_game_advanced?
      @current_player.board.advanced_count
    else
      @current_player.board.count
    end
  end

  def game_over?
    @current_player.board.won?
  end

  def play_turn
    while !attack(@current_player.get_play)
      puts "\nInvalid move.".colorize(:red)
    end
  end

  def play
    clear_and_display
    while !game_over?
      play_turn
      break if game_over?
      switch_players!
      clear_and_display
    end
    game_over_output
  end

  def ship_hit?(x, y)
    if @current_player.board.grid[x][y] == :s
      @current_player.board.grid[x][y] = :X
    end
  end

  def ship_hit!(pos)
    clear
    puts "\n    #{@current_player.name} hit a ship at #{pos}!".colorize(:red).blink
    display_and_sleep
  end

  def ship_sunk!(pos)
    clear
    puts "\n\t#{@current_player.name.upcase} HAS SUNK A SHIP!".colorize(:red).blink
    display_and_sleep
  end

  def no_ships_hit(x, y)
    clear
    @current_player.board.grid[x][y] = :x
    display_and_sleep
  end

  def switch_players!
    if @current_player == @player1
      @current_player = @player2
    else
      @current_player = @player1
    end
  end

  def display_player_stats
    puts "   " + ("_" * 28)
    shots_stats(@player1, :blue)
    ships_stats(@player1, :blue)

    shots_stats(@player2, :green)
    ships_stats(@player2, :green)
    puts "   " + ("_" * 28)
  end

private

def clear_and_display
  system ("clear")
  display
end

def display_and_sleep
  display
  sleep(3)
end

def clear
  system ("clear")
end

def choose_game_output
  puts "Enter [S] for Simple Battleship".colorize(:blue)
  puts "Enter [A] for Advanced Battleship".colorize(:cyan)
  puts "Enter [Q] to quit"
  print ": "
  input = gets.chomp.upcase
end

def welcome_output
  puts "\nWELCOME TO SIMPLE BATTLESHIP\n\n".colorize(:blue)
end

def goodbye_output
  puts "GOODBYE, CAPTAIN!".colorize(:yellow)
end

def default_game_set_up
  ship_num = ((@current_player.board.grid.length * @current_player.board.grid[0].length) * 0.1).round
  ship_num.times do
    @player1.board.place_random_ship
    @player2.board.place_random_ship
  end
  puts "\n#{ship_num} enemy ships have entered the battlefield!\n".colorize(:yellow)
end

def custom_game_set_up(input)
  input.times { @player1.board.place_random_ship }
  input.times { @player2.board.place_random_ship }
  puts "\n#{input} enemy ships have entered the battlefield!\n".colorize(:yellow)
end

def is_game_advanced?
  @game_choice == 'A'
end

def shots_stats(player, color)
  puts "\n      #{player.name.upcase}: #{player.turns} shot(s) fired.".colorize(color)
end

def ships_stats(player, color)
  if is_game_advanced?
    puts "      #{player.board.advanced_count} more ship(s) to go.".colorize(color)
  else
    puts "      #{player.board.count} more ship(s) to go.".colorize(color)
  end
end

def game_over_output
  puts "\n\tGAME OVER\n".colorize(:blue)
  puts "\t#{@current_player.name.upcase} is the battleship master!".colorize(:blue)
end

def display
  line = 0
  display_player_stats
  puts "\n\tIt's #{@current_player.name}'s turn!\n".colorize(:yellow)
  puts "\n   0  1  2  3  4  5  6  7  8  9"
  puts "   -----------------------------"
  @current_player.board.grid.each do |row|
    print "#{line}  "
    row.each do |position|
      if position == :x
        print "X  "
      elsif position == :X
        print "X  ".colorize(:red)
      else
        print "░░ "
      end
    end
    puts "\n"
    line += 1
  end
  puts "\n"
end

end

audy = HumanPlayer.new("austin", Board.new)
agne = HumanPlayer.new("agne", Board.new)
mac = ComputerPlayer.new("mac", Board.new)

game = BattleshipGame.new(agne, audy)
