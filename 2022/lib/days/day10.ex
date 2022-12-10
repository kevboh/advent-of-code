defmodule AdventOfCode.Days.Day10 do
  import AdventOfCode

  def part1 do
    input()
    |> Enum.drop(19)
    |> Enum.take_every(40)
    |> Enum.map(&Tuple.product/1)
    |> Enum.sum()
  end

  def part2 do
    for {x, i} <- input(), into: [] do
      if Integer.mod(i - 1, 40) in (x - 1)..(x + 1), do: "#", else: "."
    end
    # drop our initial accumulator value
    |> Enum.drop(-1)
    |> Enum.chunk_every(40)
    |> Enum.map(&Enum.join/1)
    |> Enum.join("\n")
    |> then(&("\n" <> &1))
  end

  defp input do
    read_input(10)
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
    # map instructions to deltas:
    # noop = 0, add = [noop, delta]
    |> Enum.flat_map(fn e ->
      case e do
        "noop" -> [0]
        "addx " <> rest -> [0, String.to_integer(rest)]
      end
    end)
    # insert start value w/ cycle index
    |> then(&[1 | &1])
    |> Enum.with_index(1)
    |> Enum.scan(fn {e, i}, {s, _} ->
      {e + s, i}
    end)
  end
end
