defmodule AdventOfCode.Grid do
  defstruct map: %{}, size: {0, 0}

  alias __MODULE__

  def from_stream(stream, map_values \\ & &1) do
    %Grid{
      map: to_map(stream, map_values),
      size: size(stream)
    }
  end

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

  def to_map(stream, map_values \\ & &1) do
    stream
    |> Stream.with_index()
    |> Enum.flat_map(fn {line, col} ->
      line
      |> String.trim()
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {c, row} -> {{row, col}, map_values.(c)} end)
    end)
    |> Enum.into(%{})
  end

  def contains?(%Grid{size: size}, point), do: contains?(size, point)
  def contains?({w, h}, {x, y}), do: x >= 0 and x < w and y >= 0 and y < h

  def neighbors(%Grid{size: size, map: map}, {x, y}, opts \\ []) do
    diagonals = Keyword.get(opts, :diagonals, false)
    map_fn = Keyword.get(opts, :map_fn, & &1)

    neighbors = [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1}
    ]

    neighbors =
      if diagonals do
        neighbors ++
          [
            {x - 1, y - 1},
            {x - 1, y + 1},
            {x + 1, y - 1},
            {x + 1, y + 1}
          ]
      else
        neighbors
      end

    neighbors
    |> Enum.filter(&contains?(size, &1))
    |> Enum.map(&map_fn.({&1, Map.get(map, &1)}))
  end

  def at(%Grid{map: map}, {x, y}), do: Map.get(map, {x, y})

  def update(%Grid{map: map} = grid, coords, value) do
    coords = List.wrap(coords)

    map = Enum.reduce(coords, map, fn coord, map -> Map.put(map, coord, value) end)

    %{grid | map: map}
  end
end
