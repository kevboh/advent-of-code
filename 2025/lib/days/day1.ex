defmodule AdventOfCode.Days.Day1 do
  @moduledoc false
  use AdventOfCode

  def part1 do
    input()
    |> Enum.reduce({50, 0}, fn rotation, {dial, zeroes} ->
      dial = rotate(dial, rotation)
      zeroes = if dial == 0, do: zeroes + 1, else: zeroes
      {dial, zeroes}
    end)
    |> inspect()
  end

  def part2 do
    input()
    |> Enum.reduce({50, 0}, fn rotation, {dial, zeroes} ->
      {dial, passes} = clicks(dial, rotation)
      {dial, zeroes + passes}
    end)
    |> inspect()
  end

  defp input do
    "1"
    |> stream_day()
    |> Stream.map(&String.trim/1)
  end

  ## Part 1

  def rotate(dial, "R" <> turns), do: do_rotate(dial, &Kernel.+/2, String.to_integer(turns))
  def rotate(dial, "L" <> turns), do: do_rotate(dial, &Kernel.-/2, String.to_integer(turns))

  def do_rotate(dial, op, turns) do
    dial = op.(dial, turns)
    Integer.mod(dial, 100)
  end

  ## Part 2

  def clicks(start, "R" <> turns) do
    clicks(start, :right, String.to_integer(turns))
  end

  def clicks(start, "L" <> turns) do
    clicks(start, :left, String.to_integer(turns))
  end

  def clicks(start, direction, turns) do
    dial = if direction == :right, do: 0..99, else: 99..0//-1

    dial
    |> Stream.cycle()
    |> Stream.drop_while(&(&1 != start))
    |> Stream.drop(1)
    |> Stream.take(turns)
    |> Enum.reduce({start, 0}, fn
      0, {_, passes} -> {0, passes + 1}
      click, {_, passes} -> {click, passes}
    end)
  end
end
