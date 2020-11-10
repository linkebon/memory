defmodule GameLogic do

  def generate_memory(words_list) do
    cards_list = Enum.map(words_list, fn word -> %Card{word: word, visible: false} end)
    for {chunk, idx} <- Enum.with_index(Enum.chunk_every(cards_list, 6)),
        into: %{},
        do: {["A", "B", "C", "D", "E", "F"] |> Enum.at(idx), chunk}
  end

  def read_words_from_file_into_list(filename), do:
    filename
    |> File.read!()
    |> String.split(~r{(\n)+})

  def matching_words?(memory, position1, position2),
      do: card_at_position(memory, position1).word == card_at_position(memory, position2).word

  def print_memory(memory) do
    for {letter, cards_list} <- memory do
      IO.puts(
        "#{letter} #{
          Enum.join(
            Enum.map(cards_list, &card_word_as_string/1),
            " "
          )
        }"
      )
    end
  end

  def card_word_as_string(card) do
    if(card.visible) do
      card.word
    else
      card.word
      #"---" TODO change to this later
    end
  end

  def card_at_position(memory, pos) do
    letter = String.at(pos, 0)
    number = case String.at(pos, 1)
                  |> Integer.parse() do
      :error -> IO.puts("\nInvalid number provided..\n")
    end
    Enum.at(memory[letter], number - 1)
  end

  def take_random_words_from_list(words_list, count_of_words) do
    randomized_words = Enum.take(
      Enum.shuffle(words_list),
      count_of_words
    )
    randomized_words ++ Enum.shuffle(randomized_words)
  end

  def update_memory_card_visible(memory, card1_pos, card2_pos) do
    key_pos1 = String.at(card1_pos, 0)
    key_pos2 = String.at(card2_pos, 0)
    current_card1 = card_at_position(memory, card1_pos)
    current_card2 = card_at_position(memory, card2_pos)
    updated_visibility_card1 = %{current_card1 | visible: true}
    updated_visibility_card2 = %{current_card2 | visible: true}
    updated_card1_list = Enum.map(
      memory[key_pos1],
      fn card ->
        if(current_card1.word == card.word) do
          updated_visibility_card1
        else
          card
        end
      end
    )
    updated_card2_list = Enum.map(
      memory[key_pos2],
      fn card ->
        if(current_card1.word == card.word) do
          updated_visibility_card2
        else
          card
        end
      end
    )
    Map.put(memory, key_pos1, updated_card1_list)
    |> Map.put(key_pos2, updated_card2_list)
  end

end