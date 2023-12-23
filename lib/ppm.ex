defmodule RayTracerElixir.PPM do
  def write(canvas) do
    lines = print_lines(canvas.pixels)
    """
    P3
    #{canvas.width} #{canvas.height}
    225
    #{lines}
    """
  end

  def lines(ppm_string) do
    String.split(ppm_string, "\n")
  end

  defp print_line(pixels) do
    pixels
    |> Enum.map(fn pixel -> "#{pixel.red} #{pixel.green} #{pixel.blue}" end)
    |> Enum.join(" ")
  end

  defp print_lines(pixel_grid) do
    pixel_grid
    |> Enum.map(&print_line/1)
    |> Enum.join("\n")
  end
end