class HumanPlayer
  attr_accessor :turns, :board, :name

  def initialize(name, board)
    @name = name
    @board = board
    @turns = 0
  end

  def get_setup
    puts "How many ships are you ready to fight? (Hit enter for default): "
    input = gets.chomp.to_i
  end

  def get_play
    puts "Please enter position to attack as 'x, y': "
    input = $stdin.gets.chomp.split(",")
    @turns += 1
    [input[0].to_i, input[1].to_i]
  end
end
