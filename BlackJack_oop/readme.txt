I've finally done my Blackjack project, which achieves all the bonus requirements and supports multi-players and multi-decks. 
I also put functions into the project for user to place bet and play gambling.
Here is the repo:

https://github.com/ClaudeJardin/week01/tree/master/BlackJack

The program starts from blackjack_main.rb, which requires the following four files:
blackjack_card.rb: methods relative to card (data structure definition, initialization and card shuffle, etc.)
blackjack_player.rb: methods relative to player (point computation, player competition, etc) 
blackjack_game.rb: methods relative to the settings and process of one game
blackjack_tools.rb: additional facility functions 

In order to facilitate data access, I used array of hash to simulate a C-structure-like method to store the 
information of game, players, and cards. The use of call-by-value and call-by-reference is a bit confusing to me.  
I observed that I can still change the content of a passed object most of the time, though. 
In addition, I found it hard to print suit symbols in a console application. Eventually, I decided to quit this part
because I was running out of time.   