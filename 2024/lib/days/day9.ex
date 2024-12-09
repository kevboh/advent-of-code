defmodule AdventOfCode.Days.Day9.File do
  defstruct [:size, :id, :position]
end

defmodule AdventOfCode.Days.Day9.Space do
  defstruct [:size, :position]
end

defmodule AdventOfCode.Days.Day9 do
  use AdventOfCode

  alias AdventOfCode.Days.Day9.File
  alias AdventOfCode.Days.Day9.Space

  def part1 do
    disk = input()

    move_one(disk, candidates(disk), [])
    |> to_blocks()
    |> checksum()
  end

  def part2 do
    disk = input()

    move_two(disk, candidates(disk))
    |> to_blocks()
    |> checksum()
  end

  defp move_one([any | rest], [next | candidates], acc) when any.position == next.position do
    move_one(rest, candidates, [next | acc])
  end

  defp move_one([any | _], [next | _], acc) when any.position > next.position do
    acc
    |> Enum.reverse()
  end

  defp move_one([%File{} = file | rest], candidates, acc) do
    move_one(rest, candidates, [file | acc])
  end

  defp move_one([%Space{} = space | rest], [next | candidates], acc)
       when space.size == next.size do
    move_one(rest, candidates, [next | acc])
  end

  defp move_one([%Space{} = space | rest], [next | candidates], acc)
       when space.size > next.size do
    move_one([%Space{space | size: space.size - next.size} | rest], candidates, [next | acc])
  end

  defp move_one([%Space{} = space | rest], [next | candidates], acc)
       when space.size < next.size do
    move_one(
      rest,
      [%File{next | size: next.size - space.size} | candidates],
      [%File{next | size: space.size} | acc]
    )
  end

  defp move_two(disk, []), do: disk

  defp move_two(disk, [file | files]) do
    moved = place(disk, file, [])
    move_two(moved, files)
  end

  defp place([c | _] = rest, file, acc) when c.position == file.position do
    Enum.reverse(acc) ++ rest
  end

  defp place([%File{} = occupied | rest], file, acc) do
    place(rest, file, [occupied | acc])
  end

  defp place([%Space{} = space | rest], file, acc) when space.size < file.size do
    place(rest, file, [space | acc])
  end

  defp place([%Space{} = space | rest], file, acc) when space.size >= file.size do
    remaining = %Space{space | size: space.size - file.size}

    # I could probably swap + merge in one pass, but.
    rest =
      Enum.map(rest, fn
        %File{} = f when f.position == file.position ->
          %Space{size: file.size, position: file.position}

        f ->
          f
      end)
      |> merge_space()

    placing =
      if remaining.size > 0 do
        [file, remaining]
      else
        [file]
      end

    Enum.reverse(acc) ++ placing ++ rest
  end

  defp place([], _, acc) do
    Enum.reverse(acc)
  end

  defp to_blocks(res) do
    res
    |> Enum.flat_map(fn
      %File{size: size, id: id} -> Stream.duplicate(id, size) |> Enum.to_list()
      %Space{size: size} -> Stream.duplicate(0, size) |> Enum.to_list()
    end)
  end

  defp checksum(blocks) do
    blocks
    |> Enum.with_index()
    |> Enum.reduce(0, fn {b, i}, acc -> acc + b * i end)
  end

  defp merge_space(disk) do
    merge_space(disk, [])
  end

  defp merge_space([%Space{} = s1 | r], [%Space{} = s2 | acc]) do
    merge_space(r, [
      %Space{size: s1.size + s2.size, position: min(s1.position, s2.position)} | acc
    ])
  end

  defp merge_space([a | r], acc) do
    merge_space(r, [a | acc])
  end

  defp merge_space([], acc), do: Enum.reverse(acc)

  defp input do
    Input.read(9)
    |> Enum.take(1)
    |> hd()
    |> to_integer_list()
    |> Enum.with_index()
    |> Enum.map(fn {v, i} ->
      if rem(i, 2) == 0 do
        %File{size: v, id: div(i, 2), position: i}
      else
        %Space{size: v, position: i}
      end
    end)
  end

  defp candidates(disk) do
    disk
    |> Enum.filter(fn
      %File{} -> true
      _ -> false
    end)
    |> Enum.reverse()
  end
end
