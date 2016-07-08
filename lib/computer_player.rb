class ComputerPlayer
  attr_accessor :turns, :name, :board

  def initialize(name, board)
    @name = name
    @board = board
    @turns = 0
  end

  def get_setup
    0
  end

  def get_play
    x, y = rand(@board.grid.length), rand(@board.grid.length)
    while !@board.is_move_valid?(x, y)
      x, y = rand(@board.grid.length), rand(@board.grid.length)
    end
    sleep(1)
    puts "#{@name} chooses position [#{x}, #{y}]"
    sleep(3)
    @turns += 1
    [x, y]
  end
end
