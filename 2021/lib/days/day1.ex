defmodule AdventOfCode.Days.Day1 do
  import AdventOfCode

  def part1 do
    input() |> count_increases |> Integer.to_string()
  end

  def part2 do
    input()
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
    |> count_increases
    |> Integer.to_string()
  end

  defp input do
    read_input(1)
    |> Enum.map(&String.to_integer/1)
  end

  defp count_increases(list) do
    dropped_first = tl(list)
    dropped_last = list |> Enum.reverse() |> tl() |> Enum.reverse()

    Enum.zip(dropped_first, dropped_last)
    |> Enum.count(fn {next, previous} -> next > previous end)
  end
end
