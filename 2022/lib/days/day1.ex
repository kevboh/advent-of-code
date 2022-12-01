defmodule AdventOfCode.Days.Day1 do
  import AdventOfCode

  def part1 do
    totals()
    |> Enum.max()
  end

  def part2 do
    totals()
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end

  defp input do
    read_input(1)
    |> Stream.map(&String.trim/1)
  end

  defp totals do
    # chunk calories by newlines
    chunk = fn element, acc ->
      if String.length(element) == 0 do
        {:cont, Enum.reverse(acc), []}
      else
        {:cont, [element |> String.to_integer() | acc]}
      end
    end

    # just emit the final chunk
    after_fun = fn
      [] ->
        {:cont, []}

      acc ->
        {:cont, acc, []}
    end

    input()
    |> Stream.chunk_while([], chunk, after_fun)
    |> Stream.map(&Enum.sum/1)
  end
end
