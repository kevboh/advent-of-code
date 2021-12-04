defmodule AdventOfCode.Days.Day3 do
  import AdventOfCode

  def part1 do
    gamma = input() |> Enum.map(&row_to_bits/1) |> common_bits()
    epsilon = gamma |> Enum.map(fn x -> 1 - x end)
    row_to_integer(gamma) * row_to_integer(epsilon)
  end

  def part2 do
    bit_rows = input() |> Enum.map(&row_to_bits/1)

    oxygen = row_to_integer(find_rating(bit_rows, :oxygen))
    co2 = row_to_integer(find_rating(bit_rows, :co2))

    oxygen * co2
  end

  defp input do
    read_input(3)
  end

  defp row_to_bits(row) do
    for <<c <- row>>, into: [], do: String.to_integer(<<c>>)
  end

  defp common_bits(rows) do
    bit_count = length(rows)

    rows
    # transpose
    |> Enum.zip()
    # convert to list and sum
    |> Enum.map(fn x -> x |> Tuple.to_list() |> Enum.sum() end)
    # average; if > 0.5, then 1 is more common, else 0
    |> Enum.map(fn s -> if s / bit_count >= 0.5, do: 1, else: 0 end)
  end

  defp row_to_integer(row) do
    s = length(row)
    <<converted::size(s)>> = for i <- row, do: <<i::1>>, into: <<>>
    converted
  end

  defp find_rating(candidates, rating_type), do: find_rating(candidates, rating_type, 0)

  defp find_rating([candidate | []], rating_type, bit_position), do: candidate

  defp find_rating(candidates, rating_type, bit_position) do
    r = common_bits(candidates)

    find_rating(
      candidates
      |> Enum.filter(fn x ->
        match_rating(Enum.at(x, bit_position), Enum.at(r, bit_position), rating_type)
      end),
      rating_type,
      bit_position + 1
    )
  end

  defp match_rating(a, b, :co2), do: a != b
  defp match_rating(a, b, _), do: a == b
end
