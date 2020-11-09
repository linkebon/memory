defmodule GameLogic do
  def read_words_from_file_into_list(filename), do:
    filename
    |> File.read!()
    |> String.split(~r{(\n)+})

  def generate_memory(words_list) do
    letters_list = ["A", "B", "C", "D", "E", "F"]
    chunked_list = Enum.chunk_every(words_list, 6)
    for(
      chunk <- chunked_list,
      letter <- letters_list,
      do: %{
        letter => chunk
      }
    )
  end


  def matching_words?(position1, position2), do: card_at_position(position1).word == card_at_position(position2).word

  def update_memory_card_visible(memory, position1, position2) do

  end

  def print_memory(memory) do

  end

  def card_at_position(pos) do

  end

  def take_random_words_from_list(words_list, count_of_words) do
    randomized_words = Enum.take(
      Enum.shuffle(words_list),
      count_of_words
    )
    randomized_words ++ Enum.shuffle(randomized_words)
  end

end