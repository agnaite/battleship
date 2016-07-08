class Ship
  attr_accessor :other_player, :current_player, :game, :ship_index

  def initialize(player1, player2, game)
    @game = game
    @current_player = player1
    @other_player = player2
  end

  def set_up_ships
    welcome_output
    set_up_ships_helper
    @current_player, @other_player = @other_player, @current_player
    set_up_ships_helper
    game_begin_output
    @game.play # STARTS THE GAME
  end

  def select_ships
    @ship_index = 0

    clear_and_display

    add_aircrafts_helper
    add_battleships_helper
    add_submarines_helper
    add_patrol_boats_helper
  end

  def add_aircraft(i)
    pos = get_ship_selection("Aircraft (5x1)")
    x, y = pos[0].to_i, pos[1].to_i

    if found_errors?(x, y, :aircraft)
      add_aircraft(i)
    else
      5.times do
        @other_player.board.grid[x][y] = :s
        @other_player.board.ships[i] << [x, y]
        x += 1
      end
    end
  end

  def add_battleship(i)
    pos = get_ship_selection("Battleship (2x2)")
    x, y = pos[0].to_i, pos[1].to_i

    if found_errors?(x, y, :battleship)
      add_battleship(i)
    else
      @other_player.board.grid[x][y] = :s
      @other_player.board.ships[i] << [x, y]

      @other_player.board.grid[x+1][y] = :s
      @other_player.board.ships[i] << [x+1, y]

      @other_player.board.grid[x][y+1] = :s
      @other_player.board.ships[i] << [x, y+1]

      @other_player.board.grid[x+1][y+1] = :s
      @other_player.board.ships[i] << [x+1, y+1]
    end
  end

  def add_submarine(i)
    pos = get_ship_selection("Submarine (2x1)")
    x, y = pos[0].to_i, pos[1].to_i

    if found_errors?(x, y, :submarine)
      add_submarine(i)
    else
      @other_player.board.grid[x][y] = :s
      @other_player.board.ships[i] << [x, y]

      @other_player.board.grid[x][y + 1] = :s
      @other_player.board.ships[i] << [x, y + 1]
    end
  end

  def add_patrol_boat(i)
    pos = get_ship_selection("Patrol Boat (1x1)")
    x, y = pos[0].to_i, pos[1].to_i

    if found_errors?(x, y, :patrol)
      add_patrol_boat(i)
    else
      @other_player.board.grid[x][y] = :s
      @other_player.board.ships[i] << [x, y]
    end
  end

  private

  def is_selection_valid?(x, y, ship)
    if ship == :aircraft
      empty = true
      (0..4).each do |i|
        if (!is_selection_empty?(x + i, y)) || !no_adjacent_ships?(x + i, y)
          empty = false
        end
      end
      return empty
    elsif ship == :battleship
      (is_selection_empty?(x, y) && no_adjacent_ships?(x, y)) &&
      (is_selection_empty?(x, y + 1) && no_adjacent_ships?(x, y + 1)) &&
      (is_selection_empty?(x + 1, y) && no_adjacent_ships?(x + 1, y)) &&
      (is_selection_empty?(x + 1, y + 1) && no_adjacent_ships?(x + 1, y + 1))
    elsif ship == :submarine
      (is_selection_empty?(x, y) && no_adjacent_ships?(x, y)) &&
      is_selection_empty?(x, y + 1) && no_adjacent_ships?(x, y + 1)
    else
      is_selection_empty?(x, y) && no_adjacent_ships?(x, y)
    end
  end

  def no_adjacent_ships?(x, y)
    (x + 1 >= @other_player.board.grid.length || is_selection_empty?(x + 1, y)) &&
    (x - 1 < 0 || is_selection_empty?(x - 1, y)) &&
    (y + 1 >= @other_player.board.grid[x].length || is_selection_empty?(x, y + 1)) &&
    (y - 1 < 0 || is_selection_empty?(x, y - 1))
  end

  def does_selection_exist(x, y)
    (x >= 0 && x < @other_player.board.grid.length) &&
    (y >= 0 && y < @other_player.board.grid[x].length)
  end

  def is_selection_empty?(x, y)
    does_selection_exist(x, y) && @other_player.board.grid[x][y].nil?
  end

  def found_errors?(x, y, ship)
    if !is_selection_valid?(x, y, ship)
      puts "\nInvalid selection, Captain.".colorize(:red)
      return true
    else
      return false
    end
  end

  def get_ship_selection(ship)
    puts "Select the position of your #{ship} as 'x, y': "
    pos = $stdin.gets.chomp.split(",")
  end

  def add_aircrafts_helper
    puts "Let's start with Aircrafts (5x1).\n".colorize(:yellow)
    2.times do
      add_aircraft(@ship_index)
      clear_and_display
      @ship_index += 1
    end
  end

  def add_battleships_helper
    puts "Moving on to Battleships (2x2).\n".colorize(:yellow)
    2.times do
      add_battleship(@ship_index)
      clear_and_display
      @ship_index += 1
    end
  end

  def add_submarines_helper
    puts "Next up are Submarines (2x1).\n".colorize(:yellow)
    3.times do
      add_submarine(@ship_index)
      clear_and_display
      @ship_index += 1
    end
  end

  def add_patrol_boats_helper
    puts "Let's finish up with Patrol Boats (1x1).\n".colorize(:yellow)
    4.times do
      add_patrol_boat(@ship_index)
      clear_and_display
      @ship_index += 1
    end
  end

  def set_up_ships_output
    puts "\n\n#{@current_player.name.upcase}, it is your turn to select your fleet.".colorize(:blue)
    puts "#{@other_player.name.upcase}, please look away."
    sleep(3)
  end

  def sleep_and_clear
    sleep(3)
    system ("clear")
  end

  def clear_and_display
    system ("clear")
    display
  end

  def set_up_ships_helper
    set_up_ships_output
    select_ships
    sleep_and_clear
  end

  def welcome_output
    puts "\nWELCOME TO ADVANCED BATTLESHIP\n\n".colorize(:cyan)
  end

  def game_begin_output
    puts "\n\n\tLET THE GAME BEGIN!".colorize(:blue)
    sleep(2)
  end

  def display
    line = 0
    puts "\n   0  1  2  3  4  5  6  7  8  9"
    puts "   -----------------------------"
    @other_player.board.grid.each do |row|
      print "#{line}  "
      row.each do |position|
        if !position.nil?
          print "O  ".colorize(:green)
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
