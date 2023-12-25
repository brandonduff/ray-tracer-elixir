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
      {left, right} = String.split_at(line, limit)
      [left, right]
    end)
    |> List.flatten()
    |> Enum.filter(fn line -> line != "" end)
    |> Enum.map(&String.trim/1)
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
    |> Enum.join("\n")
  end
end
