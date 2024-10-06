defmodule RayTracerElixir.CameraTest do
  alias RayTracerElixir.Color
  alias RayTracerElixir.Canvas
  alias RayTracerElixir.Transformation
  alias RayTracerElixir.World
  alias RayTracerElixir.Tuple
  alias RayTracerElixir.Point
  alias RayTracerElixir.Vector
  alias RayTracerElixir.Numbers
  alias RayTracerElixir.Camera
  alias RayTracerElixir.Matrix
  use ExUnit.Case, async: true

  test "Constructing a camera" do
    hsize = 160
    vsize = 120
    field_of_view = :math.pi() / 2

    c = Camera.new(hsize, vsize, field_of_view)

    assert c.hsize == 160
    assert c.vsize == 120
    assert c.transform == Matrix.identity_matrix()
  end

  test "The pixel size for a horizontal canvas" do
    c = Camera.new(200, 125, :math.pi() / 2)
    assert Numbers.close?(c.pixel_size, 0.01)
  end

  test "The pixel size for a vertical canvas" do
    c = Camera.new(125, 200, :math.pi() / 2)
    assert Numbers.close?(c.pixel_size, 0.01)
  end

  test "Constructing a ray through the center of the camera" do
    c = Camera.new(201, 101, :math.pi() / 2)

    r = Camera.ray_for_pixel(c, 100, 50)

    assert Tuple.equal?(r.origin, Point.new(0,0,0))
    assert Tuple.equal?(r.direction, Vector.new(0, 0, -1))
  end

  test "Constructing a ray through a corner of the canvas" do
    c = Camera.new(201, 101, :math.pi/2)

    r = Camera.ray_for_pixel(c, 0, 0)

    assert Tuple.equal?(r.origin, Point.new(0,0,0))
    assert Tuple.equal?(r.direction, Vector.new(0.66519, 0.33259, -0.66851))
  end

  test "Rendering a world with a camera" do
    w = World.default()
    c = Camera.new(11, 11, :math.pi/2)
    from = Point.new(0, 0, -5)
    to = Point.new(0, 0, 0)
    up = Vector.new(0, 1, 0)
    c = %{c | transform: Transformation.view_transform(from, to, up)}

    image = Camera.render(c, w)

    assert Tuple.equal?(Canvas.pixel_at(image, 5, 5), Color.new(0.38066, 0.47583, 0.2855))
  end
end
