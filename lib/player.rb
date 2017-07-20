class Player
  attr_reader :name
  attr_accessor :hand

  DICE_SIDES = [*1..6]

  def initialize(name)
    @name = name
    @hand = []
  end

  def roll_die
    result = []

    5.times { result << DICE_SIDES.sample }

    @hand = result
    puts "#{name}'s hand is #{hand}"
  end

  # returns highest count of matching sides in the hand
  def highest_match_count
    match_count = Hash.new(0)

    @hand.each { |dice| match_count[dice] += 1 }

    match_count.values.max
  end

  # finds value of die with the highest match count and returns highest value
  def highest_match_value
    values = @hand.select { |dice| @hand.count(dice) == highest_match_count }
    values.max
  end
end
