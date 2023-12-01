defmodule AdventOfCode.Days.Day17.Cycle do
  @enforce_keys [:items]
  defstruct [:items, :len, :idx]

  def new(items) do
    items =
      items
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {e, i}, acc -> Map.put(acc, i, e) end)

    %AdventOfCode.Days.Day17.Cycle{items: items, len: map_size(items), idx: 0}
  end

  def next(cycle) do
    idx = Integer.mod(cycle.idx, cycle.len)
    item = cycle.items[idx]
    {item, %{cycle | idx: idx + 1}}
  end
end

defmodule AdventOfCode.Days.Day17 do
  import AdventOfCode
  alias AdventOfCode.Days.Day17.Cycle

  def part1 do
    drop_next()
  end

  def part2 do
    "not implemented"
  end

  def drop_next(
        shapes \\ shapes(),
        jets \\ jets(),
        structure \\ MapSet.new(),
        y \\ 3,
        shape_count \\ 0
      ) do
    if shape_count == 2022 do
      draw(structure)
      yf(structure, &Enum.max/1)
    else
      {shape, shapes} = Cycle.next(shapes)
      drop(shape, shapes, structure, jets, 2, y, shape_count)
    end
  end

  def drop(shape, shapes, structure, jets, x, y, shape_count) do
    orig_x = x
    {x, base_coords} = shape_coords(shape, x, y)

    # apply jet
    {jet, jets} = Cycle.next(jets)
    jx = jet_x(jet, x)
    {jx, coords} = shape_coords(shape, jx, y)

    # check for hitting an existing rock
    {base_coords, x} =
      if(MapSet.disjoint?(coords, structure), do: {coords, jx}, else: {base_coords, x})

    IO.puts("#{jet} from #{orig_x} to #{x}")

    # drop down one
    dy = y - 1
    {x, coords} = shape_coords(shape, x, dy)

    # check for floor
    min_y = yf(coords, &Enum.min/1)

    if min_y < 0 or not MapSet.disjoint?(coords, structure) do
      # floor or other shape
      structure = MapSet.union(structure, base_coords)

      IO.puts("#{shape} landed!")

      # drop next
      max_y = yf(base_coords, &Enum.max/1)
      drop_next(shapes, jets, structure, max_y + 4, shape_count + 1)
    else
      # keep going
      drop(shape, shapes, structure, jets, x, dy, shape_count)
    end
  end

  defp yf(coords, f),
    do:
      coords
      |> MapSet.to_list()
      |> Enum.map(&elem(&1, 1))
      |> f.()

  defp input do
    read_input("17a")
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
    |> hd()
  end

  def shapes do
    Cycle.new(["-", "+", "⅃", "l", "□"])
  end

  def jets do
    input()
    |> String.codepoints()
    |> Cycle.new()
  end

  def bx(x, width), do: min(max(0, x), 7 - width)

  # x### <- y
  def shape_coords("-", x, y) do
    x = bx(x, 4)
    {x, MapSet.new([{x, y}, {x + 1, y}, {x + 2, y}, {x + 3, y}])}
  end

  # .#.
  # ###
  # x#. <- y
  def shape_coords("+", x, y) do
    x = bx(x, 3)
    {x, MapSet.new([{x + 1, y}, {x, y + 1}, {x + 1, y + 1}, {x + 2, y + 1}, {x + 1, y + 2}])}
  end

  # ..#
  # ..#
  # x## <- y
  def shape_coords("⅃", x, y) do
    x = bx(x, 3)
    {x, MapSet.new([{x, y}, {x + 1, y}, {x + 2, y}, {x + 2, y + 1}, {x + 2, y + 2}])}
  end

  # #
  # #
  # #
  # x <- y
  def shape_coords("l", x, y) do
    x = bx(x, 1)
    {x, MapSet.new([{x, y}, {x, y + 1}, {x, y + 2}, {x, y + 3}])}
  end

  # ##
  # x# <- y
  def shape_coords("□", x, y) do
    x = bx(x, 2)
    {x, MapSet.new([{x, y}, {x, y + 1}, {x + 1, y}, {x + 1, y + 1}])}
  end

  def jet_x(">", x), do: x + 1
  def jet_x("<", x), do: x - 1

  def draw(structure) do
    max_y = yf(structure, &Enum.max/1)

    for y <- max_y..0 do
      l =
        for x <- 0..6, into: "|" do
          if MapSet.member?(structure, {x, y}), do: <<"#">>, else: <<".">>
        end

      IO.puts(l <> "|")
    end
  end
end
