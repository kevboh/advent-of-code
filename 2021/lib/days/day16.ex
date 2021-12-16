defmodule AdventOfCode.Days.Day16.Packet do
  defstruct [:version, :type, :value, children: []]
end

defmodule AdventOfCode.Days.Day16 do
  import AdventOfCode

  alias AdventOfCode.Days.Day16.Packet

  def part1 do
    {p, _} = packet(input())

    sum_versions(p)
  end

  def part2 do
    {p, _} = packet(input())

    calculate(p)
  end

  def packet(b) do
    {version, b} = version(b)
    {type, b} = type(b)

    case type do
      :literal ->
        {val, rest} = value(b)
        {%Packet{version: version, type: type, value: val}, rest}

      _ ->
        {length_type, len, rest} = child_length(b)

        {children, rest} =
          if length_type == :bits do
            <<children_bits::bitstring-size(len), rest::bitstring>> = rest
            {bitwise_child_packets(children_bits), rest}
          else
            count_child_packets(rest, len)
          end

        {%Packet{version: version, type: type, children: children}, rest}
    end
  end

  def bitwise_child_packets(b, packets \\ []) do
    {p, rest} = packet(b)
    packets = [p | packets]
    if rest == <<>>, do: packets |> Enum.reverse(), else: bitwise_child_packets(rest, packets)
  end

  def count_child_packets(b, target_count, packets \\ []) do
    {p, rest} = packet(b)
    packets = [p | packets]

    if length(packets) == target_count,
      do: {packets |> Enum.reverse(), rest},
      else: count_child_packets(rest, target_count, packets)
  end

  def version(<<v::3, rest::bitstring>>), do: {v, rest}
  def type(<<t::3, rest::bitstring>>), do: {to_type(t), rest}

  def to_type(0), do: :sum
  def to_type(1), do: :product
  def to_type(2), do: :minimum
  def to_type(3), do: :maximum
  def to_type(4), do: :literal
  def to_type(5), do: :gt
  def to_type(6), do: :lt
  def to_type(7), do: :eq

  def value(<<c::1, v::4, rest::bitstring>>, segment_count \\ 1, current \\ <<>>) do
    current = <<current::bitstring, v::4>>

    if c == 1,
      do: value(rest, segment_count + 1, current),
      else: {b_to_i(current, segment_count), rest}
  end

  def child_length(<<t::1, len::15, rest::bitstring>>) when t == 0, do: {:bits, len, rest}
  def child_length(<<t::1, len::11, rest::bitstring>>) when t == 1, do: {:count, len, rest}

  defp b_to_i(a, segment_count) do
    <<i::size(segment_count)-unit(4)>> = a
    i
  end

  defp sum_versions(packet) do
    case packet.type do
      :literal -> packet.version
      _ -> packet.version + (packet.children |> Enum.map(&sum_versions(&1)) |> Enum.sum())
    end
  end

  defp calculate(packet) do
    c = packet.children |> Enum.map(&calculate/1)

    case packet.type do
      :sum ->
        c |> Enum.sum()

      :product ->
        c |> Enum.product()

      :minimum ->
        c |> Enum.min()

      :maximum ->
        c |> Enum.max()

      :literal ->
        packet.value

      :gt ->
        [c1, c2] = c
        if c1 > c2, do: 1, else: 0

      :lt ->
        [c1, c2] = c
        if c1 < c2, do: 1, else: 0

      :eq ->
        [c1, c2] = c
        if c1 == c2, do: 1, else: 0
    end
  end

  defp input do
    read_input(16) |> hd() |> Base.decode16!()
  end
end
