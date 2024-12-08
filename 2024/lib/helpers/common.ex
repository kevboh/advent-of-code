defmodule AdventOfCode.Helpers.Common do
  def wrap(a) when is_list(a), do: a
  def wrap(a), do: [a]

  def combinations(enum) do
    for x <- enum, y <- enum, x != y, do: {x, y}
  end
end
