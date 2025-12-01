defmodule AdventOfCode.Helpers.Common do
  def combinations(enum) do
    for x <- enum, y <- enum, x != y, do: {x, y}
  end

  def to_integer_list(string, sep \\ "") do
    string
    |> String.trim()
    |> String.split(sep, trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def replace_or_prepend_with(list, predicate, replacing) do
    do_replace_or_prepend_with(list, predicate, replacing, [])
  end

  defp do_replace_or_prepend_with([], _predicate, replacing, acc) do
    [replacing.(nil) | Enum.reverse(acc)]
  end

  defp do_replace_or_prepend_with([value | list], predicate, replacing, acc) do
    if predicate.(value) do
      replacement = replacing.(value)
      Enum.reverse(acc) ++ [replacement | list]
    else
      do_replace_or_prepend_with(list, predicate, replacing, [value | acc])
    end
  end
end
