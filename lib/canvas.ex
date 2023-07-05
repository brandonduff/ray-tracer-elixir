defmodule RayTracerElixir.Canvas do
  alias RayTracerElixir.Color

  def new(width, height) do
    %{width: width, height: height, pixels: init_pixels(width, height)}
  end

  def write_pixel(canvas, x, y, pixel) do
    put_in(canvas, [:pixels, Access.at(x), Access.at(y)], pixel)
  end

  def pixel_at(canvas, x, y) do
    get_in(canvas, [:pixels, Access.at(x), Access.at(y)])
  end

  defp init_pixels(width, height) do
    Enum.map(Range.new(0, height - 1), fn _ ->
      Enum.map(Range.new(0, width - 1), fn _ -> Color.new(0, 0, 0) end)
    end)
  end
end
