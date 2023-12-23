defmodule RayTracerElixir.PPMTest do
  use ExUnit.Case, async: true

  alias RayTracerElixir.Canvas
  alias RayTracerElixir.PPM
  alias RayTracerElixir.Color

  test "constructing the header" do
    c = Canvas.new(5, 3)
    ppm = PPM.write(c)
    lines = PPM.lines(ppm)

    assert Enum.slice(lines, 0..2) == ["P3", "5 3", "225"]
  end

  @tag :skip
  test "constructing PPM pixel data" do
    c = Canvas.new(5, 3)
    c1 = Color.new(1.5, 0, 0)
    c2 = Color.new(0, 0.5, 0)
    c3 = Color.new(-0.5, 0, 1)

    lines =
      c
      |> Canvas.write_pixel(0, 0, c1)
      |> Canvas.write_pixel(2, 1, c2)
      |> Canvas.write_pixel(4, 2, c3)
      |> PPM.write()
      |> PPM.lines()

    assert Enum.slice(lines, 3..5) == [
             "255 0 0 0 0 0 0 0 0 0 0 0 0 0 0",
             "0 0 0 0 0 0 0 128 0 0 0 0 0 0 0",
             "0 0 0 0 0 0 0 0 0 0 0 0 0 0 255"
           ]
  end
end
