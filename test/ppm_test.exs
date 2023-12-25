defmodule RayTracerElixir.PPMTest do
  use ExUnit.Case, async: true

  alias RayTracerElixir.Canvas
  alias RayTracerElixir.PPM
  alias RayTracerElixir.Color

  test "constructing the header" do
    c = Canvas.new(5, 3)
    ppm = PPM.write(c)
    lines = PPM.lines(ppm)

    assert Enum.slice(lines, 0..2) == ["P3", "5 3", "255"]
  end

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

  test "splitting long lines in PPM files" do
    c =
      Canvas.new(10, 2)
      |> Canvas.transform(fn canvas, x, y ->
        Canvas.write_pixel(canvas, x, y, Color.new(1, 0.8, 0.6))
      end)

    lines = PPM.write(c) |> PPM.lines()

    assert Enum.slice(lines, 3..6) == [
             "255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204",
             "153 255 204 153 255 204 153 255 204 153 255 204 153",
             "255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204",
             "153 255 204 153 255 204 153 255 204 153 255 204 153"
           ]
  end
end
