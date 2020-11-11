defmodule GameLogic do
  @moduledoc """
  Documentation for `GameLogic`.
  Module contains the game logic for running memory game
  """

  @doc """
  Generates a memory with the structure:
  %{'A' => [Card], 'B' => [Card] ... }
  """
  def generate_memory(words_filename) do
    words_list = words_filename
                 |> File.read!()
                 |> String.split(~r{(\n)+})
                 |> take_random_words_from_list(18)
    cards_list = Enum.map(words_list, fn word -> %Card{word: word, visible: false} end)
    for {chunk, idx} <- Enum.with_index(Enum.chunk_every(cards_list, 6)),
        into: %{},
        do: {
          ["A", "B", "C", "D", "E", "F"]
          |> Enum.at(idx),
          chunk
        }
  end

  def matching_words?(memory, position1, position2),
      do: card_at_position(memory, position1).word == card_at_position(memory, position2).word

  def print_memory(memory) do
    IO.puts("\n-------------------------")
    for {letter, cards_list} <- memory do
      IO.puts("#{letter} #{Enum.join(Enum.map(cards_list, &card_word_as_string/1), " ")}")
    end
    IO.puts("-------------------------\n")
  end

  def card_word_as_string(card) do
    if(card.visible) do
      card.word
    else
      "---"
    end
  end

  def card_at_position(memory, pos) do
    letter = String.at(pos, 0)
    number = case String.at(pos, 1)
                  |> Integer.parse() do
      {parsed, _} -> parsed
      :error -> IO.puts("\nInvalid number provided..\n")
    end
    Enum.at(memory[letter], number - 1)
  end

  def take_random_words_from_list(words_list, count_of_words) do
    randomized_words = Enum.take(Enum.shuffle(words_list), count_of_words)
    randomized_words ++ Enum.shuffle(randomized_words)
  end

  def update_card_at_pos_visible(memory, pair_pos1, visible) do
    key_pos1 = String.at(pair_pos1, 0)
    current_card = card_at_position(memory, pair_pos1)
    updated_visibility_card = %{current_card | visible: visible}
    Map.put(
      memory,
      key_pos1,
      Enum.map(
        memory[key_pos1],
        fn card ->
          if(current_card.word == card.word) do
            updated_visibility_card
          else
            card
          end
        end
      )
    )
  end

  def reset_card_positions_visibility(memory, pair_pos1, pair_pos2) do
    update_card_at_pos_visible(memory, pair_pos1, false)
    |> update_card_at_pos_visible(pair_pos2, false)
  end

  def game_finished?(memory) do
    Map.values(memory) # structure: [[], [], []]
    |> List.flatten
    |> Enum.all?(&(&1.visible)) # check if all cards have visibility true
  end
end