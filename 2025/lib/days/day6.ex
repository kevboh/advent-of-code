defmodule AdventOfCode.Days.Day6 do
  @moduledoc false
  use AdventOfCode

  def part1 do
    input()
    |> Enum.reduce(nil, fn
      line, nil ->
        String.split(line)

      line, acc ->
        parts = String.split(line)

        for {part, col} <- Enum.zip(parts, acc) do
          [part | List.wrap(col)]
        end
    end)
    |> Enum.map(fn [op | col] ->
      {op, col |> Enum.reverse() |> Enum.map(&String.to_integer/1)}
    end)
    |> Enum.map(&solve/1)
    |> Enum.sum()
  end

  def part2 do
    # Adding comments since I feel like I solved this kind of weirdly.
    # First, convert the input to lists of characters and get the longest line length.
    lines = Enum.map(input(), &String.graphemes/1)
    max_line_length = lines |> Enum.map(&Enum.count/1) |> Enum.max()

    # Pad all lines to max length with spaces.
    lines = padded_to_without_newlines(lines, max_line_length)

    # Transpose the lines (Enum.zip/1 + Tuple.to_list/1)
    lines
    |> Enum.zip()
    |> Enum.flat_map(fn problem ->
      # Pull out the operations.
      [op | problem] =
        problem
        |> Tuple.to_list()
        |> Enum.reverse()

      # Either convert the digits into an integer or remove the interstitial spaces.
      case problem
           |> Enum.reverse()
           |> Enum.join()
           |> String.trim() do
        "" -> []
        number -> [{op, String.to_integer(number)}]
      end
    end)
    # Do the cephalopod math, building up lists of ops and then applying the op.
    |> Enum.reduce({nil, [], 0}, fn
      {" ", number}, {op, current, sum} ->
        {op, [number | current], sum}

      {op, number}, acc ->
        sum = solve_reduce(acc)

        {op, [number], sum}
    end)
    # The reduce leaves us with one problem aggregated but not solved; solve it.
    |> solve_reduce()
  end

  defp solve({"+", col}) do
    Enum.sum(col)
  end

  defp solve({"*", col}) do
    Enum.product(col)
  end

  defp solve_reduce({nil, _current, sum}), do: sum
  defp solve_reduce({op, current, sum}), do: sum + solve({op, current})

  defp input do
    stream_day(6)
  end

  defp padded_to_without_newlines(lines, length) do
    Enum.map(lines, fn line ->
      line = Enum.drop(line, -1)
      len = Enum.count(line)

      if len < length do
        line ++ Enum.map(len..(length - 1), fn _ -> " " end)
      else
        line
      end
    end)
  end
end
