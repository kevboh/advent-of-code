defmodule AdventOfCode.Days.Day8 do
  import AdventOfCode

  @segments %{
    "abcefg" => 0,
    "cf" => 1,
    "acdeg" => 2,
    "acdfg" => 3,
    "bcdf" => 4,
    "abdfg" => 5,
    "abdefg" => 6,
    "acf" => 7,
    "abcdefg" => 8,
    "abcdfg" => 9
  }

  @helpful_segments_by_length %{
    # 1
    2 => ["c", "f"],
    # 4
    4 => ["b", "c", "d", "f"],
    # 7
    3 => ["a", "c", "d"]
  }

  def part1 do
    e2 = fn x -> elem(x, 1) end

    outputs =
      signals_outputs()
      |> Enum.flat_map(e2)
      |> Enum.map(&String.length/1)
      |> Enum.frequencies()

    # 1 has 2 segments, 4 = 4, 7 = 3, 8 = 7
    search = MapSet.new([2, 4, 3, 7])

    Map.to_list(outputs)
    |> Enum.filter(fn {s, _} -> MapSet.member?(search, s) end)
    |> Enum.map(e2)
    |> Enum.sum()
  end

  def part2 do
    signals_outputs()
    |> Enum.map(fn {s, o} ->
      solution = solve(%{}, s ++ o)
      o |> Enum.map(fn o -> decode_output(solution, o) end) |> Integer.undigits()
    end)
    |> Enum.sum()
  end

  defp input do
    read_input(8)
  end

  defp signals_outputs do
    input()
    |> Enum.map(fn i ->
      [raw_signal, raw_output] =
        i
        |> String.split("|", trim: true)
        |> Enum.map(fn x -> String.split(x, " ", trim: true) end)

      {raw_signal, raw_output}
    end)
  end

  defp solve(possibilities, signal) do
    # start with 1 to get c, f
    false_segments = signal |> Enum.find(fn s -> String.length(s) == 2 end) |> String.graphemes()
    {possibilities, excluding} = seed_possible(possibilities, false_segments)

    # then do 4 to get d, b
    false_segments = signal |> Enum.find(fn s -> String.length(s) == 4 end) |> String.graphemes()
    {possibilities, excluding} = seed_possible(possibilities, false_segments, excluding)

    # then 7, which will determine a [a]
    false_segments = signal |> Enum.find(fn s -> String.length(s) == 3 end) |> String.graphemes()
    {possibilities, excluding} = seed_possible(possibilities, false_segments, excluding)

    # do 5-segment numbers, which are 2, 3, and 5
    {possibilities, _} =
      for s <- signal |> Enum.filter(fn x -> String.length(x) == 5 end),
          reduce: {possibilities, excluding} do
        {ap, ae} ->
          segments = s |> String.graphemes() |> MapSet.new()
          new = segments |> MapSet.difference(excluding)

          case MapSet.size(new) do
            2 ->
              # 2 will have 2 new possible segments, eg, but also solves [c] from 1
              ap = Map.update!(ap, "c", fn set -> MapSet.intersection(set, segments) end)
              ap = Map.put(ap, "e", new)
              ap = Map.put_new(ap, "g", new)
              {ap, ae}

            1 ->
              # 3 will have 1 new segment, g [g]
              # 5 will have 1 new segment, g [g]
              ap = Map.put(ap, "g", new)
              {ap, ae}

            _ ->
              {ap, ae}
          end
      end

    # once you have c, you can get f [acfg]
    c = possibilities["c"]
    possibilities = Map.update!(possibilities, "f", fn f -> MapSet.difference(f, c) end)

    # at this point you can solve e by looking at g
    g = possibilities["g"]
    possibilities = Map.update!(possibilities, "e", fn e -> MapSet.difference(e, g) end)

    # 6-segment numbers
    # hunt for a 0, as 6 and 9 don't give us enough new info to solve
    b = possibilities["b"]
    d = possibilities["d"]

    possibilities =
      for s <- signal |> Enum.filter(fn x -> String.length(x) == 6 end),
          reduce: possibilities do
        ap ->
          segments = s |> String.graphemes() |> MapSet.new()
          bi = MapSet.intersection(b, segments)
          di = MapSet.difference(d, segments)

          update = if MapSet.size(bi) == 1, do: %{"b" => bi, "d" => di}, else: %{}
          Map.merge(ap, update)
      end

    encode_solution(possibilities)
  end

  defp seed_possible(possibilities, false_segments, excluding \\ MapSet.new()) do
    true_segments = @helpful_segments_by_length[length(false_segments)]
    to_put = MapSet.difference(MapSet.new(false_segments), excluding)

    possibilities =
      for t <- true_segments, reduce: possibilities do
        acc ->
          Map.put_new(acc, t, to_put)
      end

    {possibilities, MapSet.union(to_put, excluding)}
  end

  defp encode_solution(possibilities) do
    possibilities
    |> Map.to_list()
    |> Enum.map(fn {k, v} -> {v |> MapSet.to_list() |> hd(), k} end)
    |> Map.new()
  end

  defp decode_output(solution, output) do
    key =
      output
      |> String.graphemes()
      |> Enum.map(&Map.get(solution, &1))
      |> Enum.sort()
      |> Enum.join()

    @segments[key]
  end
end
