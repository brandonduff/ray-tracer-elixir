defmodule CanvasTest do
  use ExUnit.Case, async: true

  alias RayTracerElixir.Color
  alias RayTracerElixir.Canvas
  alias RayTracerElixir.Tuple

  test "creating a canvas" do
    c = Canvas.new(10, 20)
    assert c.width == 10
    assert c.height == 20
    assert length(c.pixels) == 20
    assert length(hd(c.pixels)) == 10
    assert length(List.flatten(c.pixels)) == 200
    Enum.each(List.flatten(c.pixels), &Tuple.equal?(Color.new(0, 0, 0), &1))
  end

  test "writing a pixel to the canvas" do
    c = Canvas.new(10, 20)
    red = Color.new(1, 0, 0)

    c = Canvas.write_pixel(c, 2, 3, red)

    assert Tuple.equal?(Canvas.pixel_at(c, 2, 3), red)
  end
end
