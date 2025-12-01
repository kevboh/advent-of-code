defmodule AdventOfCode.Days.Day12.Region do
  defstruct [:value, plots: MapSet.new()]

  alias __MODULE__

  # 1411460 too low

  def merge(%Region{value: value, plots: a_plots}, %Region{value: value, plots: b_plots}) do
    %Region{value: value, plots: MapSet.union(a_plots, b_plots)}
  end

  def area(%Region{plots: plots}), do: MapSet.size(plots)

  def perimeter(%Region{plots: plots}) do
    plots
    |> MapSet.to_list()
    |> Enum.reduce(0, fn {x, y}, acc ->
      [
        {x - 1, y},
        {x + 1, y},
        {x, y - 1},
        {x, y + 1}
      ]
      |> Enum.reject(&MapSet.member?(plots, &1))
      |> Enum.count()
      |> Kernel.+(acc)
    end)
  end
end

defmodule AdventOfCode.Days.Day12 do
  use AdventOfCode

  alias AdventOfCode.Days.Day12.Region

  def part1 do
    input()
    |> to_regions()
    |> IO.inspect(label: "regions")
    |> Enum.flat_map(&elem(&1, 1))
    |> Enum.map(fn region ->
      area = Region.area(region)
      perimeter = Region.perimeter(region)

      area * perimeter
    end)
    |> Enum.sum()
  end

  def part2 do
    "not implemented"
  end

  defp to_regions(grid, regions \\ %{}, at \\ {0, 0})

  defp to_regions(%Grid{size: {_, h}} = grid, regions, {_, y}) when y >= h do
    regions
    |> Enum.map(fn {k, v} -> {k, merge_regions(grid, v)} end)
    |> Enum.into(%{})
  end

  defp to_regions(%Grid{size: {w, _}} = grid, regions, {x, y}) when x >= w do
    to_regions(grid, regions, {0, y + 1})
  end

  defp to_regions(grid, regions, {x, y} = at) do
    value = Grid.at(grid, at)

    default_region = %Region{value: value, plots: MapSet.new([at])}

    regions =
      Map.update(regions, value, [default_region], fn regions ->
        replace_or_prepend_with(regions, &contiguous_to?(grid, &1, {at, value}), fn
          %Region{} = region -> %Region{region | plots: MapSet.put(region.plots, at)}
          nil -> default_region
        end)
      end)

    to_regions(grid, regions, {x + 1, y})
  end

  defp merge_regions(grid, [first | regions]) do
    regions
    |> Enum.reduce([first], fn region, acc ->
      replace_or_prepend_with(acc, &contiguous_to?(grid, region, &1), fn
        %Region{} = candidate -> Region.merge(region, candidate)
        nil -> region
      end)
    end)
  end

  defp contiguous_to?(grid, %Region{plots: a_plots, value: value}, %Region{
         plots: b_plots,
         value: value
       }) do
    a_plots =
      a_plots
      |> Enum.flat_map(&Grid.neighbors(grid, &1, fn v -> elem(v, 0) end))
      |> MapSet.new()

    b_plots
    |> Enum.any?(&MapSet.member?(a_plots, &1))
  end

  defp contiguous_to?(grid, %Region{plots: plots, value: value}, {at, value}) do
    Grid.neighbors(grid, at, &elem(&1, 0))
    |> Enum.any?(&MapSet.member?(plots, &1))
  end

  defp contiguous_to?(_, _, _), do: false

  defp input do
    Input.read(12)
    |> Grid.from_stream()
  end
end
