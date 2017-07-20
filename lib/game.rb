require_relative 'player'

class Game
  def initialize(players)
    @remaining_players = players
    @game_over = false
  end

  def play
    until @game_over
      play_round
      @game_over = true if @remaining_players.length == 1
    end

    puts "#{@remaining_players[0].name} owes everyone a drink!"
  end

  def play_round
    @remaining_players.each(&:roll_die)
    evaluate_round
    print "Continue? (y/n) "
    input = gets.chomp
    @game_over = true if input == "n"
  end

  def evaluate_round
    potential_winners = players_with_largest_matches

    if potential_winners.length == 1
      @remaining_players.reject! do |player|
        player == potential_winners[0]
      end
      puts "#{potential_winners[0].name} wins this round!"
    elsif potential_winners.length > 1
      potential_winners = players_with_largest_match_value(potential_winners)
      if potential_winners.length > 1
        puts "It's a tie! No winners this round."
      else
        @remaining_players.reject! do |player|
          player == potential_winners[0]
        end
        puts "#{potential_winners[0].name} wins this round!"
      end
    elsif potential_winners.empty?
      puts "No winners this round!"
    end
  end

  def players_with_largest_matches
    potential_winners = @remaining_players.select do |player|
      player.hand.include?(1)
    end

    largest_match_count = potential_winners.reduce do |winner, next_player|
      if next_player.highest_match_count > winner.highest_match_count
        next_player
      else
        winner
      end
    end.highest_match_count

    potential_winners.select do |player|
      player.highest_match_count == largest_match_count
    end
  end

  def players_with_largest_match_value(players)
    largest_match_value = players.reduce do |winner, next_player|
      if next_player.highest_match_value > winner.highest_match_value
        next_player
      else
        winner
      end
    end.highest_match_value

    players.select do |player|
      player.highest_match_value == largest_match_value
    end
  end
end

if __FILE__ == $0
  print "Please enter the number of players: "
  player_count = gets.chomp.to_i

  players = []
  player_count.times do
    print "Please enter player's name: "
    players << Player.new(gets.chomp)
  end

  game = Game.new(players)
  game.play
end
