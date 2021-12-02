defmodule AdventOfCode do
  @moduledoc """
  Documentation for `AdventOfCode`.
  """

  def read_input(day) do
    {:ok, data} = File.read("priv/inputs/#{day}.txt")

    data
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(fn x -> String.length(x) > 0 end)
  end
end
