defmodule Memory do

  def run_memory() do
    memory = GameLogic.generate_memory("memoUTF8.txt")
    guess(memory)
  end

  def guess(memory, guess_count \\ 1) do
    if(GameLogic.game_finished?(memory)) do
      IO.puts("*** Memory finished!! You finished in #{guess_count} guesses! ***")
    else

      guess1 = IO.gets("Guess pair one: ")
      memory = GameLogic.update_card_at_pos_visible(memory, guess1, true)
      GameLogic.print_memory(memory)
      guess2 = IO.gets("Guess pair two: ")
      memory = GameLogic.update_card_at_pos_visible(memory, guess2, true)
      GameLogic.print_memory(memory)
      memory = case GameLogic.matching_words?(memory, guess1, guess2) do
        true -> IO.puts("Correct word! #{GameLogic.card_at_position(memory, guess1).word}")
                memory
        false -> GameLogic.reset_card_positions_visibility(memory, guess1, guess2)
      end
      guess(memory, guess_count + 1)
    end
  end
end
