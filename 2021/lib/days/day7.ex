defmodule AdventOfCode.Days.Day7 do
  import AdventOfCode

  def part1 do
    {starts, min, max} = parse()

    Enum.to_list(min..max)
    |> Flow.from_enumerable()
    |> Flow.map(fn i -> sum(starts, i) end)
    |> Enum.min()
  end

  def part2 do
    {starts, min, max} = parse()

    Enum.to_list(min..max)
    |> Flow.from_enumerable()
    |> Flow.map(fn i -> sum2(starts, i) end)
    |> Enum.min()
  end

  defp input do
    read_input(7)
  end

  defp parse() do
    starts = input() |> hd() |> String.split(",") |> Enum.map(&String.to_integer/1)
    min = Enum.min(starts)
    max = Enum.max(starts)
    {starts, min, max}
  end

  defp sum(starts, i) do
    starts
    |> Flow.from_enumerable()
    |> Flow.map(fn x -> abs(x - i) end)
    |> Enum.to_list()
    |> Enum.sum()
  end

  defp sum2(starts, i) do
    starts
    |> Flow.from_enumerable()
    |> Flow.map(fn x ->
      n = abs(x - i)
      trunc(n * (n + 1) / 2)
    end)
    |> Enum.to_list()
    |> Enum.sum()
  end
end
