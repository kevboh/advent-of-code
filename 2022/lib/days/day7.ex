defmodule AdventOfCode.Days.Day7.State do
  alias AdventOfCode.Days.Day7.State

  defstruct path: [], tree: %{"/" => %{}}

  def cd(s = %State{path: []}, ".."), do: s
  def cd(s = %State{path: [_ | rest]}, ".."), do: %{s | path: rest}
  def cd(s, "/"), do: %{s | path: ["/"]}
  def cd(s = %State{path: path}, d), do: %{s | path: [d | path]}

  def put(s, "dir " <> dir) do
    put(s, dir, %{})
  end

  def put(s, file_desc) do
    [size, name] = String.split(file_desc, " ")
    put(s, name, String.to_integer(size))
  end

  defp put(s, key, value) do
    tree =
      update_in(s.tree, Enum.reverse(s.path), fn k ->
        Map.put(k, key, value)
      end)

    %{s | tree: tree}
  end
end

defmodule AdventOfCode.Days.Day7 do
  import AdventOfCode

  alias AdventOfCode.Days.Day7.State

  def part1 do
    input()
    |> Enum.to_list()
    |> Enum.filter(fn {_, v} -> v <= 100_000 end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def part2 do
    dirs = input()
    available = 70_000_000 - dirs["/"]

    dirs
    |> Enum.to_list()
    |> Enum.map(&elem(&1, 1))
    |> Enum.sort(:asc)
    |> Enum.find(fn v -> v + available >= 30_000_000 end)
  end

  defp input do
    read_input(7)
    |> Stream.map(&String.trim/1)
    |> Stream.reject(&String.starts_with?(&1, "$ ls"))
    |> Enum.reduce(%AdventOfCode.Days.Day7.State{}, &reduce/2)
    |> Map.get(:tree)
    |> dir_sizes()
  end

  defp reduce("$ cd " <> path, s), do: State.cd(s, path)
  defp reduce(file_folder, s), do: State.put(s, file_folder)

  defp dir_sizes(v, path \\ [], acc \\ %{})

  defp dir_sizes(size, [_filename | path], acc) when is_integer(size) do
    path
    |> all_paths()
    |> Enum.reduce(acc, fn p, a -> Map.update(a, p, size, &(&1 + size)) end)
  end

  defp dir_sizes(tree, path, acc) do
    tree
    |> Map.to_list()
    |> Enum.reduce(acc, fn {k, v}, acc ->
      dir_sizes(v, [k | path], acc)
    end)
  end

  defp all_paths(p, acc \\ [])
  defp all_paths([], acc), do: acc
  defp all_paths([p], acc), do: [p | acc]

  defp all_paths(path = [_ | rest], acc) do
    ps =
      path
      |> Enum.reverse()
      |> Enum.join("/")
      # i'm so tired
      |> String.replace_prefix("//", "/")

    all_paths(rest, [ps | acc])
  end
end
