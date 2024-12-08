defmodule AdventOfCode.Days.Day7 do
  import AdventOfCode

  def part1 do
    sum_solutions([&Kernel.+/2, &Kernel.*/2])
  end

  defp concat(i, j), do: String.to_integer("#{i}#{j}")

  def part2 do
    sum_solutions([&Kernel.+/2, &Kernel.*/2, &concat/2])
  end

  defp sum_solutions(ops) do
    input()
    |> Enum.map(fn {solution, terms} ->
      if solvable?(solution, terms, ops), do: solution
    end)
    |> Enum.reject(&is_nil/1)
    |> Enum.sum()
  end

  defp solvable?(solution, [term | rest], ops) do
    solution_tree(solution, term, rest, ops)
    |> List.flatten()
    |> Enum.any?()
  end

  defp solution_tree(solution, solution, [], _), do: true
  defp solution_tree(_, _, [], _), do: false

  defp solution_tree(solution, curr, [term | rest], ops) do
    Enum.map(ops, &solution_tree(solution, &1.(curr, term), rest, ops))
  end

  defp input do
    read_input(7)
    |> Stream.map(&parse_line/1)
  end

  defp parse_line(line) do
    [solution | terms] =
      line
      |> String.trim()
      |> String.split(" ", trim: true)

    solution =
      solution
      |> String.trim_trailing(":")
      |> String.to_integer()

    terms = Enum.map(terms, &String.to_integer/1)

    {solution, terms}
  end
end
