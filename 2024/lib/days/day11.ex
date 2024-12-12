defmodule AdventOfCode.Days.Day11 do
  use AdventOfCode

  def part1 do
    blink(input(), 25) |> Enum.count()
  end

  def part2 do
    blink_two(input(), 75) |> Map.values() |> Enum.sum()
  end

  # Preserving the naive approach for part one.
  def blink(stones, remaining) do
    stones = Enum.flat_map(stones, &next/1)

    if remaining == 1, do: stones, else: blink(stones, remaining - 1)
  end

  def blink_two(stones, times) do
    # Start with the number of times each stone occurs
    freqs = Enum.frequencies(stones)

    # For each iteration…
    Enum.reduce(1..times, freqs, fn _, freqs ->
      # for each {stone, count} tuple…
      freqs
      |> Enum.reduce(%{}, fn {num, count}, freqs ->
        # Swap it with its next state and memoize the updated count
        next(num)
        |> Enum.reduce(freqs, fn num, freqs ->
          Map.update(freqs, num, count, &(&1 + count))
        end)
      end)
    end)
  end

  def next("0"), do: ["1"]

  def next(digits) do
    len = String.length(digits)

    if rem(len, 2) == 0 do
      {head, tail} = String.split_at(digits, div(len, 2))

      [
        simplify(head),
        simplify(tail)
      ]
    else
      v = String.to_integer(digits)
      [Integer.to_string(v * 2024)]
    end
  end

  defp simplify(str) do
    str
    |> String.to_integer()
    |> Integer.to_string()
  end

  defp input do
    Input.read(11)
    |> Enum.take(1)
    |> hd()
    |> String.trim()
    |> String.split(" ", trim: true)
  end
end
