defmodule AdventOfCode do
  @moduledoc """
  Documentation for `AdventOfCode`.
  """

  defmacro __using__(_) do
    quote do
      import AdventOfCode
    end
  end

  def stream_day(day) do
    File.stream!("priv/inputs/#{day}.txt")
  end
end
