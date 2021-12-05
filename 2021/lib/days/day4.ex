defmodule AdventOfCode.Days.Day4 do
  import AdventOfCode

  alias AdventOfCode.Days.Day4.Board

  def part1 do
    {numbers, boards} = parse()

    {_winning_board, {_direction, _index}, score} = part1_solve(numbers, boards)

    # IO.puts("#{score} won on #{Atom.to_string(direction)} #{index}")
    score
  end

  def part2 do
    {numbers, boards} = parse()
    part2_solve(numbers, boards)
  end

  defp input do
    read_input(4)
  end

  defp parse() do
    [called_string | rest] = input()

    {String.split(called_string, ",", trim: true),
     Enum.chunk_every(rest, 5) |> Enum.map(&Board.new/1)}
  end

  defp part1_solve(numbers, boards) do
    [call | rest] = numbers

    result =
      boards
      |> Enum.reduce({[], :none}, fn board, {acc, status} ->
        case Board.draw_and_check(board, call) do
          {board, false} -> {[board | acc], status}
          {board, win} -> {[board | acc], {board, win}}
        end
      end)

    case result do
      {boards, :none} ->
        part1_solve(rest, boards)

      {_, {winning_board, win}} ->
        {winning_board, win, Board.sum_uncalled(winning_board) * String.to_integer(call)}
    end
  end

  defp part2_solve(numbers, [board]) do
    [call | rest] = numbers

    case Board.draw_and_check(board, call) do
      {board, false} -> part2_solve(rest, [board])
      {board, _} -> Board.sum_uncalled(board) * String.to_integer(call)
    end
  end

  defp part2_solve(numbers, boards) do
    [call | rest] = numbers

    remaining =
      boards
      |> Enum.reduce([], fn board, acc ->
        case Board.draw_and_check(board, call) do
          {board, false} -> [board | acc]
          _ -> acc
        end
      end)

    part2_solve(rest, remaining)
  end
end

defmodule AdventOfCode.Days.Day4.Board do
  defstruct [:positions, :uncalled, called: MapSet.new(), progress: %{}]

  def new(row_strings) do
    positions =
      for {row, ri} <- Enum.with_index(row_strings, 1), reduce: %{} do
        acc ->
          rowcols = String.split(row, " ", trim: true)

          for {val, ci} <- Enum.with_index(rowcols, 1), reduce: acc do
            inner ->
              Map.put(inner, val, {ri, ci + 5})
          end
      end

    %AdventOfCode.Days.Day4.Board{
      positions: positions,
      uncalled: MapSet.new(Map.keys(positions))
    }
  end

  def draw_and_check(board, number) do
    case Map.get(board.positions, number) do
      {ri, ci} ->
        %{called: called, uncalled: uncalled, progress: progress} = board

        board = %{
          board
          | called: called |> MapSet.put(number),
            uncalled: uncalled |> MapSet.delete(number),
            progress:
              progress
              |> Map.update(ri, 1, &(&1 + 1))
              |> Map.update(ci, 1, &(&1 + 1))
        }

        cond do
          board.progress[ri] == 5 -> {board, {:row, ri}}
          board.progress[ci] == 5 -> {board, {:col, ci - 5}}
          true -> {board, false}
        end

      _ ->
        {board, false}
    end
  end

  def sum_uncalled(board) do
    board.uncalled
    |> MapSet.to_list()
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end
end
