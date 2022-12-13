defmodule AdventOfCode.Days.Day13 do
  import AdventOfCode
  import NimbleParsec

  list =
    ignore(string("["))
    |> repeat(
      choice([
        parsec(:packet) |> wrap(),
        integer(min: 1)
      ])
      |> ignore(optional(string(",")))
    )
    |> ignore(string("]"))

  defparsec(:packet, list)

  def part1 do
    input()
    |> Stream.map(&parse/1)
    |> Stream.map(fn [l, r] -> compare(l, r) end)
    |> Stream.with_index(1)
    |> Stream.filter(&elem(&1, 0))
    |> Stream.map(&elem(&1, 1))
    |> Enum.sum()
  end

  @decoders [[[2]], [[6]]]

  def part2 do
    input()
    |> Stream.flat_map(&parse/1)
    |> Enum.to_list()
    |> then(&(@decoders ++ &1))
    |> Enum.sort(&compare/2)
    |> Enum.with_index(1)
    |> Enum.filter(fn {e, _} -> e in @decoders end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.product()
  end

  defp input do
    read_input(13)
    |> Stream.map(&String.trim/1)
    |> Stream.chunk_every(2, 3)
  end

  defp parse([l, r]), do: [elem(packet(l), 1), elem(packet(r), 1)]

  defp compare(l, r) do
    {:halt, res} = do_compare(l, r)
    res
  end

  defp do_compare(l, l) when is_integer(l), do: :cont
  defp do_compare(l, r) when is_integer(l) and is_integer(r), do: {:halt, l < r}
  defp do_compare([], []), do: :cont
  defp do_compare([], r) when is_list(r), do: {:halt, true}
  defp do_compare(l, []) when is_list(l), do: {:halt, false}

  defp do_compare(l, r) when is_list(l) and is_integer(r) do
    do_compare(l, [r])
  end

  defp do_compare(l, r) when is_integer(l) and is_list(r) do
    do_compare([l], r)
  end

  defp do_compare([lh | lr], [rh | rr]) do
    case do_compare(lh, rh) do
      {:halt, res} -> {:halt, res}
      :cont -> do_compare(lr, rr)
    end
  end
end
