defmodule RayTracerElixir.Canvas do
  alias RayTracerElixir.Color

  def new(width, height) do
    %{width: width, height: height, pixels: init_pixels(width, height)}
  end

  def write_pixel(canvas, x, y, pixel) do
    put_in(canvas, [:pixels, Access.at(y), Access.at(x)], pixel)
  end

  def pixel_at(canvas, x, y) do
    get_in(canvas, [:pixels, Access.at(y), Access.at(x)])
  end

  def transform(canvas, transformer) do
    Enum.reduce(Range.new(0, canvas.width - 1), canvas, fn x, c ->
      Enum.reduce(Range.new(0, canvas.height - 1), c, fn y, acc ->
        transformer.(acc, x, y)
      end)
    end)
  end

  defp init_pixels(width, height) do
    for _i <- 0..(height - 1) do
      for _j <- 0..(width - 1) do
        Color.new(0, 0, 0)
      end
    end
  end
end
