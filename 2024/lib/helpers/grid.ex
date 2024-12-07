defmodule AdventOfCode.Helpers.Grid do
  def size(stream) do
    width =
      Stream.take(stream, 1)
      |> Enum.to_list()
      |> hd()
      |> String.trim()
      |> String.length()

    height =
      stream
      |> Stream.reject(&(String.trim(&1) == ""))
      |> Enum.count()

    {width, height}
  end

  def to_map(stream) do
    stream
    |> Stream.with_index()
    |> Enum.flat_map(fn {line, col} ->
      line
      |> String.trim()
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {c, row} -> {{row, col}, c} end)
    end)
    |> Enum.into(%{})
  end
end
