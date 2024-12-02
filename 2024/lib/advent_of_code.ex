defmodule AdventOfCode do
  @moduledoc """
  Documentation for `AdventOfCode`.
  """

  def read_input(day) do
    File.stream!("priv/inputs/#{day}.txt")
  end
end
