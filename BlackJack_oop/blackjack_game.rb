
require_relative 'blackjack_card'
require_relative 'blackjack_player'

class Blackjack_game
  def initialize game_players, game_cards, game_odds
    @players = game_players
	@cards = game_cards
	@odds = game_odds
	@status = 'Continue'
	@rounds = 1
  end
  def continue?
    if @status == 'Continue'
      return true
    end
    false
  end
  def quit
    @status = 'Quit'
  end
  
  def start  
    @cards.refresh
    show_text_banner('Round ' + @rounds.to_s, 1)
    @players.show_table
  
    @players.new_game
    turn = (@players.dealer + 1) % @players.count
    #Betting
    show_text_banner('Place Chips', 1)
    while turn != @players.dealer
      player = @players[turn]
	  if player.bankrupt?
	    turn = (turn + 1) % @players.count
	    next
	  end
	  print player.name + ': '
	  bet = 0
	  if player.is_human == 1
	    bet = gets.chomp.to_i
	    bet = (bet > player.total_chips)? player.total_chips : bet 
	  else
	    thinking(2)
	    bet = player.compute_bet(@odds)
	    puts bet.to_s
	  end
	  player.bet = bet
	  turn = (turn + 1) % @players.count
    end
    puts ''
  
    #Initial dealing
    show_text_banner('Initial Dealing', 1)
    @players.each do |player|
      if !player.bankrupt?
	    visible = (player == @players.dealer_player)? false : true
        card_dealing(player, visible)
	    card_dealing(player, visible)
	  end
    end
  
    self.game_result
    puts ''
  
    #Dealing card
    turn = (@players.dealer + 1) % @players.count
    while turn != @players.dealer
	  player = @players[turn]
	  if player.bankrupt?
	    turn = (turn + 1) % @players.count
	    next
	  end
	
	  if player.state == 'normal'
        if player.is_human == 1
	      show_text_banner('Your Turn', 1)
	    else
	      show_text_banner(player.name + '\'s Turn', 1)
	    end
	  end
	
      answer = 0
	  while answer != 2
	    if player.state == 'normal'
	      status_string = show_result(player, 1)
		  option_string = '[H]it/[S]tay: '
	      print option_string
		
	      if player.is_human == 1 
	        answer = hit_or_stay
	      else
		    thinking(2)    #pretending that the computer is thinking
	        answer = player.computer_hit_or_stay
		    puts ((answer == 1)? 'Hit' : 'Stay')
	      end
	      if answer == 1
	        card_dealing(player, true)
		    sum = player.points
		  
		    if sum == 21 || sum > 21
		      show_result(player, 1)
			  puts ''
		    end
	      end
	    else
	      answer = 2
        end		
	  end
	  puts ''
	  turn = (turn + 1) % @players.count
    end
  
    #dealer hit
    dealer_player = @players.dealer_player
	dealer_player.show_cards
    if dealer_player.state == 'normal' && dealer_player.points < 17
      show_text_banner('Dealer\'s Turn', 1)
      sum = dealer_player.compute_sum
      show_result(dealer_player, 1)
      while sum < 17
	    print 'Hit'
	    puts ''
        sleep(2)
        card_dealing(dealer_player, true)
	    sum = dealer_player.compute_sum
	    show_result(dealer_player, 1)
	    if dealer_player.state != 'normal' || sum >= 17
	      puts ''
	    end
      end
      puts ''
    end
  
    #competition
    @players.compete

    #output result
    show_text_banner('Result', 1)
    self.game_result
  end 
  
  def restart
    puts ''
    print 'OK! Game Restart'
    thinking(1)
    puts ''
    system('cls')
    @rounds = @rounds + 1
  end
  def card_dealing player, visible
    @cards[0].visible = visible
    player.get_card(@cards[0])
    player.points = player.compute_sum
    @cards.pop_card
    player.update_state
  end
  def hit_or_stay
    answer = 0
    answer = gets.chomp.downcase
    if answer == 'h'
      return 1
    end
    2
  end
  def game_result
    puts 'Dealer:'
    show_result(@players.dealer_player, 1) 
    puts ''
    puts ''
    puts 'Player:'
    @players.each do |player|
      if player != @players.dealer_player
	    if player.bankrupt?
	      next
	    end
	    player.result_update(@players.dealer_player, @odds)
	    show_result(player, 1)
	    print ' '
	    if player.state == 'won'
	      print '$' + player.total_chips.to_s.rjust(4) + ' (+' + (player.bet.to_f * @odds).to_i.to_s.rjust(4) + ')'
	    elsif player.state == 'lost'
	      print '$' + player.total_chips.to_s.rjust(4) + ' (-' + player.bet.to_s.rjust(4) + ')'
	    end
	    puts ''
	  end
    end 
    puts ''  
  end
  def show_result player, status_visible
    flag = player.card_invisble?
    status_string = (player.state == 'normal' || status_visible == 0 || flag == true)? '' : player.state.capitalize.ljust(4)
    point_string = (flag == true)? '?' : player.points.to_s
    print_string = (player.name + ': ').ljust(10) + player.get_cards_string.ljust(25) + 'Points=' + point_string.to_s.ljust(11) + '  ' + status_string
    print print_string
    print_string  
   end
end



















