defmodule RayTracerElixir.PPM do
  alias RayTracerElixir.Color

  @scale 255

  def write(canvas) do
    lines = print_lines(canvas.pixels)

    """
    P3
    #{canvas.width} #{canvas.height}
    #{@scale}
    #{lines}
    """
  end

  def lines(ppm_string) do
    ppm_string |> IO.iodata_to_binary() |> String.split("\n")
  end

  def ensure_line_limit(lines, limit) do
    Enum.chunk_while(
      lines,
      %{current_line: [], current_length: 0},
      fn element, acc ->
        if IO.iodata_length(element) + acc.current_length >= limit do
          {:cont, [acc.current_line | ["\n"]],
           %{current_line: [element], current_length: IO.iodata_length(element)}}
        else
          {:cont, collect_element(acc, element)}
        end
      end,
      fn acc -> {:cont, [acc.current_line], acc} end
    )
  end

  defp collect_element(%{current_length: 0, current_line: current_line}, element) do
    %{
      current_line: [current_line | [element]],
      current_length: IO.iodata_length(element)
    }
  end

  defp collect_element(acc, element) do
    %{
      current_line: [acc.current_line | [" ", element]],
      current_length: IO.iodata_length(element) + acc.current_length + 1
    }
  end

  defp print_line(pixels) do
    pixels
    |> Enum.map(&Color.scale(&1, @scale))
    |> Enum.flat_map(fn pixel ->
      [to_string(pixel.red), to_string(pixel.green), to_string(pixel.blue)]
    end)
  end

  defp print_lines(pixel_grid) do
    pixel_grid
    |> Enum.flat_map(&print_line/1)
    |> ensure_line_limit(70)
  end
end
