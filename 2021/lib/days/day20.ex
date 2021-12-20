defmodule AdventOfCode.Days.Day20 do
  import AdventOfCode

  @input 20

  def part1 do
    {algo, image} = input()

    abby_i_said_ENHANCE(algo, image, 2) |> print_image() |> count_lit_pixels()
  end

  def part2 do
    "not implemented"
  end

  defp abby_i_said_ENHANCE(_, image, 0), do: image

  defp abby_i_said_ENHANCE(algo, image, times) do
    print_image(image)
    scannable = scannable_image(image)
    enhanced_image = enhance(algo, scannable)
    abby_i_said_ENHANCE(algo, enhanced_image, times - 1)
  end

  defp enhance(algo, lines, enhanced_image \\ [])

  defp enhance(_, [], enhanced_image), do: enhanced_image |> Enum.reverse()

  defp enhance(algo, [lines = {_, center, _} | rest], enhanced_image) do
    # scan through the tuple of lines, creating a new line to append to enhanced_image

    # IO.inspect(lines)

    new_line =
      for i <- 0..(String.length(center) - 3), into: "" do
        sq = pixel_square_at(lines, i)

        index =
          sq
          |> Enum.map(&value/1)
          |> Enum.into(<<>>, fn bit -> <<bit::1>> end)
          |> then(fn i ->
            <<index::9>> = i
            index
          end)

        v = Map.get(algo, index)

        # IO.inspect(sq, label: "square at #{i}")
        # IO.puts("evaluates to #{index} of value: #{v}")

        v
      end

    # IO.puts(new_line)

    enhance(algo, rest, [new_line | enhanced_image])
  end

  defp pixel_square_at({top, center, bottom}, i) do
    <<_::binary-size(i), tl::binary-size(1), tm::binary-size(1), tr::binary-size(1), _::binary>> =
      top

    <<_::binary-size(i), cl::binary-size(1), cm::binary-size(1), cr::binary-size(1), _::binary>> =
      center

    <<_::binary-size(i), bl::binary-size(1), bm::binary-size(1), br::binary-size(1), _::binary>> =
      bottom

    [tl, tm, tr, cl, cm, cr, bl, bm, br]
  end

  defp scannable_image(image_lines) do
    width = 4 + (image_lines |> hd() |> String.length())

    e = dark_line(width)
    padded_lines = image_lines |> Enum.map(fn l -> ".." <> l <> ".." end)
    padded_image = [e] ++ padded_lines ++ [e]

    Enum.zip([[e | padded_image], padded_image, tl(padded_image) ++ [e]])
  end

  defp input do
    [algo | image] = read_input(@input)

    # IO.puts(algo)

    algo =
      algo
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {a, b} -> {b, a} end)
      |> Map.new()

    {algo, image}
  end

  defp value("."), do: 0
  defp value("#"), do: 1

  defp dark_line(width) do
    for _ <- 1..width, into: "", do: "."
  end

  defp print_image(image) do
    for l <- image, do: IO.puts(l)
    image
  end

  defp count_lit_pixels(image) do
    image |> Enum.flat_map(&String.graphemes/1) |> Enum.filter(&(&1 == "#")) |> length()
  end
end
