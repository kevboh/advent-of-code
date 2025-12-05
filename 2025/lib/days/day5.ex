defmodule AdventOfCode.Days.Day5 do
  @moduledoc false
  use AdventOfCode

  def part1 do
    {ranges, available} = input()
    Enum.count(available, fn a -> Enum.any?(ranges, &(a in &1)) end)
  end

  def part2 do
    {ranges, _} = input()

    ranges
    |> merge_ranges()
    |> Enum.sum_by(&Range.size/1)
  end

  defp merge_ranges([range | rest]), do: merge_ranges(rest, [range])

  defp merge_ranges([], acc), do: acc

  defp merge_ranges([range | rest], acc) do
    # get intersections
    {intersections, others} = Enum.split_with(acc, &(not Range.disjoint?(&1, range)))

    # merge range with intersections
    merged =
      Enum.reduce(intersections, range, fn r1, r2 ->
        first = min(r1.first, r2.first)
        last = max(r1.last, r2.last)
        first..last
      end)

    merge_ranges(rest, [merged | others])
  end

  defp input do
    {ranges, [_ | available]} =
      5
      |> stream_day()
      |> Stream.map(&String.trim/1)
      |> Enum.split_while(&(&1 != ""))

    {Enum.map(ranges, &to_range/1), Enum.map(available, &String.to_integer/1)}
  end

  defp to_range(range) do
    %{"s" => s, "e" => e} = Regex.named_captures(~r/(?<s>\d+)-(?<e>\d+)/, range)
    Range.new(String.to_integer(s), String.to_integer(e))
  end
end
