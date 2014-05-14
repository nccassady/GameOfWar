require 'deck-of-cards'

# Create a new deck
deck = DeckOfCards.new
deck.shuffle

# Each "player" is an array of cards
player1 = []
player2 = []

gameNotOver = true # State variable to keep the game going or not
war = false # For if the game starts out as a war
round = 0 # Round counter
inPlay = {} # Keeps track of cards currently in play
output = "" # Keeps track of all output to write to the file all at once

# Divide the deck between both players
while deck.cards.length > 0
  player1 << deck.draw
  player2 << deck.draw
end

# Game loop
while gameNotOver
  # Only increment round number if it is not a war
  unless war
    round += 1
    output += "Round #{round}: "

    # Draw cards from both players
    inPlay = {player1: [player1.shift], player2: [player2.shift]}
  else
    # If there is a war, add to the cards currently in play
    player1.shift(2).each { |card| inPlay[:player1] << card }
    player2.shift(2).each { |card| inPlay[:player2] << card }
  end

  output += "Player 1 plays #{inPlay[:player1][-1]}, player 2 plays #{inPlay[:player2][-1]}. "

  # Check the last card each player drew and determine the winner
  if inPlay[:player1][-1] > inPlay[:player2][-1]
    inPlay[:player1].each { |card| player1 << card }
    inPlay[:player2].each { |card| player1 << card }
    war = false
    output += "Player 1 wins! "
  elsif inPlay[:player1][-1] < inPlay[:player2][-1]
    inPlay[:player1].each { |card| player2 << card }
    inPlay[:player2].each { |card| player2 << card }
    war = false
    output += "Player 2 wins! "
  else # If no winner, declare war
    war = true
    output += "War!\r\n"
  end

# Print the score on non-war rounds
  unless war
    output += "Current score: Player 1: #{player1.length}, Player 2: #{player2.length}\r\n"
  end
 
# If either player is empty, and there is no war, the game ends
  if player1.empty? || player2.empty?
    unless war
      gameNotOver = false
      output += player1.empty? ? "Player 2 wins the game!" : "Player 1 wins the game!"
    end
    # Or if the game has gone on for 1000 rounds, end it and declare the player with more cards the winner
  elsif round >= 1000
    if player1.length > player2.length
      output += "Player 1 is the winner after #{round} rounds with #{player1.length} cards"
    elsif player1.length < player2.length
      output += "Player 2 is the winner after #{round} rounds with #{player2.length} cards"
    else
      output += "The game is declared a draw after #{round} rounds"
    end
    gameNotOver = false
  end
end

File.write("GameOfWarResults.txt", output)