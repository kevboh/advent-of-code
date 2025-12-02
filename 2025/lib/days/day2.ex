defmodule AdventOfCode.Days.Day2 do
  use AdventOfCode

  def part1 do
    invalid_ids_for_predicate(&repeats_twice?/1)
    |> Enum.sum()
  end

  def part2 do
    invalid_ids_for_predicate(&all_repeats?/1)
    |> Enum.sum()
  end

  defp invalid_ids_for_predicate(predicate) do
    input()
    |> Enum.flat_map(fn {s, e} ->
      Enum.filter(s..e, fn number ->
        predicate.(number)
      end)
    end)
  end

  def repeats_twice?(number) do
    number = Integer.to_string(number)
    match?({a, a}, String.split_at(number, div(String.length(number), 2)))
  end

  def all_repeats?(number) when number <= 10, do: false

  # There are all sorts of optimizations available here but the laziest possible thing
  # is to just check every possible pattern.
  def all_repeats?(number) do
    codepoints =
      number
      |> Integer.to_string()
      |> String.codepoints()

    Enum.any?(1..(Enum.count(codepoints) - 1), fn segment ->
      case codepoints
           |> Enum.chunk_every(segment)
           |> Enum.frequencies()
           |> Map.to_list() do
        [{_pattern, count}] when count >= 2 ->
          true

        _ ->
          false
      end
    end)
  end

  defp input do
    stream_day("2")
    |> Enum.to_list()
    |> List.first()
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(fn pair ->
      [s, e] = String.split(pair, "-")
      s = String.trim(s) |> String.to_integer()
      e = String.trim(e) |> String.to_integer()
      # Range will warn with an implied negative step;
      # to make the future easier, always order here.
      # We don't actually have to do this to get the right answer
      # but I dislike warnings.
      if s < e, do: {s, e}, else: {e, s}
    end)
  end
end
