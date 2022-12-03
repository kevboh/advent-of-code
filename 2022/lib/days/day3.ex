defmodule AdventOfCode.Days.Day3 do
  import AdventOfCode

  def part1 do
    input()
    |> Stream.map(&common_type/1)
    |> Stream.map(&score/1)
    |> Enum.sum()
  end

  def part2 do
    input()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.codepoints/1)
    |> Stream.chunk_every(3)
    |> Stream.map(&badge/1)
    |> Stream.map(&score/1)
    |> Enum.sum()
  end

  defp input do
    read_input(3)
  end

  defp common_type(line) do
    {c1, c2} = line |> String.split_at(floor(String.length(line) / 2))
    s1 = MapSet.new(String.codepoints(c1))
    s2 = MapSet.new(String.codepoints(c2))

    MapSet.intersection(s1, s2)
    |> Enum.to_list()
    |> hd()
  end

  defp score(c) when is_binary(c), do: score(String.to_charlist(c))
  # lowercase letters
  defp score(c) when hd(c) >= 97, do: hd(c) - 96
  # uppercase letters
  defp score(c), do: hd(c) - 38

  defp badge([a, b, c]) do
    MapSet.intersection(MapSet.new(a), MapSet.new(b))
    |> MapSet.intersection(MapSet.new(c))
    |> Enum.to_list()
    |> hd()
  end
end
