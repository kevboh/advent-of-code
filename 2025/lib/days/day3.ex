defmodule AdventOfCode.Days.Day3 do
  use AdventOfCode

  def part1 do
    input()
    |> Enum.map(&joltage_in(&1, 2))
    |> Enum.sum()
  end

  def part2 do
    input()
    |> Enum.map(&joltage_in(&1, 12))
    |> Enum.sum()
  end

  defp joltage_in(bank, digit_count) do
    Enum.reduce(digit_count..1//-1, {"", -1}, fn up_to, {builder, last_idx} ->
      {digit, idx} = largest_in(bank, (last_idx + 1)..-up_to//1)
      {"#{builder}#{digit}", last_idx + 1 + idx}
    end)
    |> elem(0)
    |> String.to_integer()
  end

  defp largest_in(bank, range) do
    bank
    |> Enum.slice(range)
    |> Enum.with_index()
    |> Enum.max_by(fn {v, _} -> v end)
  end

  defp input do
    stream_day("3")
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn line ->
      line
      |> String.codepoints()
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
