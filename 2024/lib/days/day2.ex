defmodule AdventOfCode.Days.Day2 do
  use AdventOfCode

  def part1 do
    solve(&safe_one/1)
  end

  def part2 do
    solve(&safe_two/1)
  end

  defp input do
    Input.read(2)
  end

  defp solve(solver) do
    input()
    |> Stream.map(&(parse(&1) |> solver.()))
    |> Enum.count(& &1)
  end

  defp parse(report) do
    report
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  defp safe_one(report) do
    diffs =
      report
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [a, b] -> a - b end)

    (Enum.all?(diffs, &pos?/1) or Enum.all?(diffs, &neg?/1)) and
      Enum.all?(diffs, &okay?/1)
  end

  defp pos?(n), do: n > 0
  defp neg?(n), do: n < 0
  defp okay?(n), do: abs(n) >= 1 and abs(n) <= 3

  # This is terribly inefficient but I have an appointment this morning, so.
  defp safe_two(report) do
    safe_two([], report)
  end

  defp safe_two(head, [x | tail]) do
    if safe_one(head ++ tail) do
      true
    else
      safe_two(head ++ [x], tail)
    end
  end

  defp safe_two(_head, []), do: false
end
