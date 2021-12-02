defmodule AdventOfCode.Days.Day1 do
  def part1 do
    list = input_list()
    count = count_increases(list)
    Integer.to_string(count)
  end

  def part2 do
    list = input_list()
    windows = list |> Enum.chunk_every(3, 1, :discard) |> Enum.map(&Enum.sum/1)
    count = count_increases(windows)
    Integer.to_string(count)
  end

  defp input_list do
    {:ok, data} = File.read("priv/inputs/1.txt")

    data
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(fn x -> String.length(x) > 0 end)
    |> Enum.map(&String.to_integer/1)
  end

  defp count_increases(list) do
    dropped_first = tl(list)
    dropped_last = list |> Enum.reverse() |> tl() |> Enum.reverse()

    Enum.zip(dropped_first, dropped_last)
    |> Enum.count(fn {next, previous} -> next > previous end)
  end
end
