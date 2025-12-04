defmodule AdventOfCode.Days.Day2 do
  @moduledoc false
  use AdventOfCode

  def part1 do
    (&repeats_twice?/1)
    |> invalid_ids_for_predicate()
    |> Enum.sum()
  end

  def part2 do
    (&all_repeats?/1)
    |> invalid_ids_for_predicate()
    |> Enum.sum()
  end

  defp invalid_ids_for_predicate(predicate) do
    Enum.flat_map(input(), fn {s, e} ->
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
    "2"
    |> stream_day()
    |> Enum.to_list()
    |> List.first()
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(fn pair ->
      [s, e] = String.split(pair, "-")
      s = s |> String.trim() |> String.to_integer()
      e = e |> String.trim() |> String.to_integer()
      # Range will warn with an implied negative step;
      # to make the future easier, always order here.
      # We don't actually have to do this to get the right answer
      # but I dislike warnings.
      if s < e, do: {s, e}, else: {e, s}
    end)
  end
end
