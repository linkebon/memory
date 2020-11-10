defmodule GameLogic do

  def test() do
    memory = generate_memory("memoUTF8.txt")

    #guess1 = IO.gets("pair guess 1: ")
    #guess2 = IO.gets("pair guess 2: ")
    #memory = update_card_at_pos_visible(memory, "A1")
    #memory = update_memory_pair_found(memory, "E1", "F6")
    #memory = update_memory_pair_found(memory, "E6", "B4")

    memory = update_card_at_pos_visible(memory, "A1", true)
             |> update_card_at_pos_visible("A2", true)
             |> update_card_at_pos_visible("A3", true)
             |> update_card_at_pos_visible("A4", true)
             |> update_card_at_pos_visible("A5", true)
             |> update_card_at_pos_visible("A6", true)
             |> update_card_at_pos_visible("B6", true)
             |> update_card_at_pos_visible("B1", true)
             |> update_card_at_pos_visible("B2", true)
             |> update_card_at_pos_visible("B3", true)
             |> update_card_at_pos_visible("B4", true)
             |> update_card_at_pos_visible("B5", true)
             |> update_card_at_pos_visible("C6", true)
             |> update_card_at_pos_visible("C1", true)
             |> update_card_at_pos_visible("C2", true)
             |> update_card_at_pos_visible("C3", true)
             |> update_card_at_pos_visible("C4", true)
             |> update_card_at_pos_visible("C5", true)
             |> update_card_at_pos_visible("D6", true)
             |> update_card_at_pos_visible("D1", true)
             |> update_card_at_pos_visible("D2", true)
             |> update_card_at_pos_visible("D3", true)
             |> update_card_at_pos_visible("D4", true)
             |> update_card_at_pos_visible("D5", true)
             |> update_card_at_pos_visible("E6", true)
             |> update_card_at_pos_visible("E1", true)
             |> update_card_at_pos_visible("E2", true)
             |> update_card_at_pos_visible("E3", true)
             |> update_card_at_pos_visible("E4", true)
             |> update_card_at_pos_visible("E5", true)
             |> update_card_at_pos_visible("F6", true)
             |> update_card_at_pos_visible("F1", true)
             |> update_card_at_pos_visible("F2", true)
             |> update_card_at_pos_visible("F3", true)
             |> update_card_at_pos_visible("F4", true)
             |> update_card_at_pos_visible("F5", false)
    print_memory memory
    IO.puts(game_finished? memory)

  end

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

  def guessed_pair_correct?(memory, pair_pos1, pair_pos2, guess_number \\ 0) do
    if(matching_words?(memory, pair_pos1, pair_pos2)) do
      if(game_finished?(memory)) do
        IO.puts("*** Memory finished!! You finished in #{guess_number} guesses! ***")
      else
        memory
      end
    else
      reset_card_positions_visibility(memory, pair_pos1, pair_pos2)
    end
  end

  def matching_words?(memory, position1, position2),
      do: card_at_position(memory, position1).word == card_at_position(memory, position2).word

  def print_memory(memory) do
    for {letter, cards_list} <- memory do
      IO.puts("#{letter} #{Enum.join(Enum.map(cards_list, &card_word_as_string/1), " ")}")
    end
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

  def reset_card_positions_visibility(memory, pair_pos1, pair_pos2), do:
    update_card_at_pos_visible(memory, pair_pos1, false)
    |> update_card_at_pos_visible(pair_pos2, false)

  def game_finished?(memory) do
    Map.values(memory) # structure: [[], [], []]
    |> List.flatten
    |> Enum.all?(&(&1.visible)) # check if all cards have visibility true
  end
end