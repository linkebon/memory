defmodule Memory do
  @moduledoc """
  Documentation for `Memory`.
  Module contains the game user interaction with the players
  """

  def start() do
    memory = GameLogic.generate_memory("memoUTF8.txt")
    guess(memory)
  end

  def guess(memory, guess_count \\ 1) do
    if(GameLogic.game_finished?(memory)) do
      IO.puts("*** Memory finished!! You finished in #{guess_count} guesses! ***")
    else
      GameLogic.print_memory(memory)
      guess1 = guess_word(memory)
      memory = GameLogic.update_card_at_pos_visible(memory, guess1, true)
      GameLogic.print_memory(memory)
      guess2 = guess_word(memory)
      memory = GameLogic.update_card_at_pos_visible(memory, guess2, true)
      GameLogic.print_memory(memory)
      memory = case GameLogic.matching_words?(memory, guess1, guess2) do
        true -> IO.puts("Correct word: #{GameLogic.card_at_position(memory, guess1).word}\n")
                memory
        false -> IO.puts("Wrong guess.. Guess1: #{GameLogic.card_at_position(memory, guess1).word} Guess2: #{GameLogic.card_at_position(memory, guess2).word}\n")
                 GameLogic.reset_card_positions_visibility(memory, guess1, guess2)
      end
      guess(memory, guess_count + 1)
    end
  end

  def guess_word(memory) do
    guess = IO.gets("Guess pair: ")
            |> String.trim()

    case String.match?(guess, ~r{([A-Z][1-6])}) do
      false -> IO.puts("Format has to be [A-F][1-6] ex: A1. Try again..")
               guess_word(memory)
      _ -> case already_visible_card?(memory, guess) do
             true -> IO.puts("You have chosen a position which is already visible or does not exist.. Try again")
                     guess_word(memory)
             _ -> guess
           end
    end
  end

  def already_visible_card?(memory, guess), do: GameLogic.card_at_position(memory, guess).visible
end
