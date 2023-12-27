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
    String.split(ppm_string, "\n")
  end

  def ensure_line_limit(lines, limit) do
    Enum.map(lines, fn line ->
      values = String.split(line)

      Enum.reduce(values, [[]], fn value, [current_line | lines] ->
        number_of_spaces = length(current_line) - 1
        character_count = Enum.map(current_line, &String.length/1) |> Enum.sum()

        if number_of_spaces + character_count + String.length(value) < limit do
          [current_line ++ [value] | lines]
        else
          [[value] | [current_line | lines]]
        end
      end) |> Enum.reverse()
    end)
    |> Enum.map(fn lines ->
      Enum.map(lines, &Enum.join(&1, " "))
    end)
    |> List.flatten()
  end

  defp print_line(pixels) do
    pixels
    |> Enum.map(&Color.scale(&1, @scale))
    |> Enum.map(fn pixel -> "#{pixel.red} #{pixel.green} #{pixel.blue}" end)
    |> Enum.join(" ")
  end

  defp print_lines(pixel_grid) do
    pixel_grid
    |> Enum.map(&print_line/1)
    |> ensure_line_limit(70)
    |> Enum.join("\n")
  end
end
