defmodule AdventOfCode do
  @moduledoc """
  Documentation for `AdventOfCode`.
  """

  defmacro __using__(_) do
    quote do
      import AdventOfCode.Helpers.Common

      alias AdventOfCode.Helpers.Input
      alias AdventOfCode.Helpers.Grid
    end
  end
end
