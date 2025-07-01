defmodule RayTracerElixir.Canvas do
  alias RayTracerElixir.Color

  def new(width, height) do
    %{width: width, height: height, pixels: init_pixels(width, height)}
  end

  def write_pixel(canvas, x, y, pixel) do
    Map.put(canvas, :pixels, :array.set(location(canvas, x, y), pixel, canvas.pixels))
  end

  def pixel_at(canvas, x, y) do
    :array.get(location(canvas, x, y), canvas.pixels)
  end

  def transform(canvas, transformer) do
    pixels = :array.map(transformer, canvas.pixels)
    Map.put(canvas, :pixels, pixels)
  end

  defp location(canvas, x, y) do
    y * canvas.width + x
  end

  defp init_pixels(width, height) do
    size = width * height
    :array.new(size, default: Color.new(0, 0, 0))
  end
end
