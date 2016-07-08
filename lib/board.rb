class Board
  attr_accessor :grid, :ships

  def initialize(grid = nil)
    @grid = grid
    @grid = Board.default_grid if @grid.nil?
    @ships = [[],[],[],[],[],[],[],[],[],[],[]]
  end

  def count
    ship_count = 0
    @grid.each_with_index { |row| ship_count += row.count(:s) }
    ship_count
  end

  def advanced_count
    ship_count = 0
    @ships.each do |row|
      if row.any?
        ship_count += 1
      end
    end
    ship_count
  end

  def remove_from_ships(x, y)
    @ships.each_with_index do |row, row_index|
      row.each_with_index do |pos, pos_index|
        if @ships[row_index][pos_index] == [x, y]
          @ships[row_index].delete_at(pos_index)
        end
      end
    end
  end

  def not_boundary?(x, y)
    (x > 0 && x < @grid.length) && (y > 0 && y < @grid.length)
  end

  def empty?(pos = nil)
    empty_board = true
    if pos.nil?
      @grid.each do |row|
        empty_board = false if row.count(nil) < @grid.length
      end
    else
      x, y = pos[0], pos[1]
      return @grid[x][y].nil?
    end
    empty_board
  end

  def full?
    full_board = true
    @grid.each { |row| full_board = false if row.count(nil) != 0 }
    full_board
  end

  def place_random_ship
    raise "Board is full." if full?
    pos = get_random_position
    while !empty?(pos)
      pos = get_random_position
    end
    x, y = pos[0], pos[1]
    @grid[x][y] = :s
  end

  def get_random_position
    x, y = rand(@grid.length), rand(@grid.length)
    [x, y]
  end

  def is_move_valid?(x, y)
    if (y >= 0 && y < @grid.length) && (x >= 0 && x < @grid[0].length)
      return @grid[x][y] == :s || @grid[x][y].nil?
    end
    return false
  end

  def won?
    return true if empty?
    ships_left = false
    @grid.each do |row|
      ships_left = true if row.count(:s) > 0
    end
    !ships_left
  end

  def self.default_grid
    grid = []
    10.times { grid << [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil] }
    grid
  end
end
