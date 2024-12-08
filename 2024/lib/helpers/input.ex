defmodule AdventOfCode.Helpers.Input do
  def read(day) do
    File.stream!("priv/inputs/#{day}.txt")
  end
end
