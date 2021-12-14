defmodule AdventOfCode.Days.Day14 do
  import AdventOfCode

  def part1 do
    run(10)
  end

  def part2 do
    run(40)
  end

  defp run(steps) do
    {template, rules} = parse()

    template =
      for _i <- 1..steps, reduce: template do
        t -> step(t, rules)
      end

    score(template)
  end

  defp input do
    read_input(14)
  end

  defp parse do
    [start | rest] = input()

    start_chars = start |> String.graphemes()

    template =
      Enum.zip(start_chars, Enum.drop(start_chars, 1))
      |> Enum.map(fn {a, b} -> a <> b end)
      |> Enum.frequencies()

    rules =
      rest
      |> Enum.reject(fn line -> String.length(line) == 0 end)
      |> Enum.reduce(%{}, fn line, acc ->
        [pair, result] = String.split(line, " -> ", trim: true)
        Map.put(acc, pair, result)
      end)

    {template, rules}
  end

  defp step(template, rules) do
    rules
    |> Map.to_list()
    |> Enum.reduce(template, fn {pair, insertion}, acc ->
      # get current pair count
      # do this from template arg to avoid applying rules in sequence
      old = template[pair]

      if old != nil && old != 0 do
        # set current pair count to zero
        acc = Map.update(acc, pair, 0, &(&1 - old))

        # update count for both new pairs
        [first, second] = String.graphemes(pair)

        acc
        |> Map.update(first <> insertion, old, &(&1 + old))
        |> Map.update(insertion <> second, old, &(&1 + old))
      else
        acc
      end
    end)
  end

  defp score(template) do
    values =
      template
      |> Map.keys()
      |> Enum.flat_map(&String.graphemes/1)
      |> Enum.uniq()
      |> Enum.map(&score(template, &1))

    Enum.max(values) - Enum.min(values)
  end

  defp score(template, element) do
    template
    |> Map.to_list()
    |> Enum.filter(fn {k, _v} -> String.contains?(k, element) end)
    |> Enum.map(fn {k, v} ->
      if k == element <> element, do: v * 2, else: v
    end)
    |> Enum.sum()
    |> then(&(&1 / 2))
    |> round()
  end
end
