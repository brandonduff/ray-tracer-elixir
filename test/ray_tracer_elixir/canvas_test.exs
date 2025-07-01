defmodule RayTracerElixir.CanvasTest do
  use ExUnit.Case, async: true

  alias RayTracerElixir.Color
  alias RayTracerElixir.Canvas
  alias RayTracerElixir.Tuple

  test "creating a canvas" do
    c = Canvas.new(10, 20)
    assert c.width == 10
    assert c.height == 20
    Enum.each(:array.to_list(c.pixels), &Tuple.equal?(Color.new(0, 0, 0), &1))
  end

  test "writing a pixel to the canvas" do
    c = Canvas.new(10, 20)
    red = Color.new(1, 0, 0)

    c = Canvas.write_pixel(c, 2, 3, red)

    assert Tuple.equal?(Canvas.pixel_at(c, 2, 3), red)
  end
end
