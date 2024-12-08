defmodule AdventOfCode.Helpers.Common do
  def combinations(enum) do
    for x <- enum, y <- enum, x != y, do: {x, y}
  end
end
