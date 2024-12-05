defmodule AdventOfCode.Days.Day5 do
  import AdventOfCode

  def part1 do
    {correct, _} = chunked_updates()

    correct
    |> Enum.map(&middle/1)
    |> Enum.sum()
  end

  def part2 do
    {_, incorrect} = chunked_updates()

    incorrect
    |> Enum.map(&middle/1)
    |> Enum.sum()
  end

  defp chunked_updates() do
    [rules, updates] = input()

    orderings = orderings(rules)
    updates = Enum.map(updates, &parse_update/1)
    sorted_updates = Enum.map(updates, &sorted_update(&1, orderings))

    {correct, incorrect} =
      Enum.zip(updates, sorted_updates)
      |> Enum.split_with(fn {a, b} -> a == b end)

    {
      Enum.map(correct, &elem(&1, 0)),
      Enum.map(incorrect, &elem(&1, 1))
    }
  end

  defp input do
    read_input(5)
    |> Stream.map(&String.trim/1)
    |> Stream.filter(&(&1 != ""))
    |> Enum.chunk_by(&String.contains?(&1, "|"))
  end

  defp orderings(rules) do
    rules
    |> Enum.map(&String.split(&1, "|"))
    |> Enum.flat_map(fn [a, b] ->
      a = must_int(a)
      b = must_int(b)

      [
        {{a, b}, true},
        {{b, a}, false}
      ]
    end)
    |> Enum.into(%{})
  end

  defp parse_update(update) do
    update
    |> String.split(",")
    |> Enum.map(&must_int/1)
  end

  defp sorted_update(update, orderings) do
    Enum.sort(update, fn a, b -> Map.get(orderings, {a, b}, false) end)
  end

  defp must_int(a), do: Integer.parse(a) |> elem(0)

  defp middle(list) do
    count = Enum.count(list)
    {a, _} = List.pop_at(list, floor(count / 2))
    a
  end
end
