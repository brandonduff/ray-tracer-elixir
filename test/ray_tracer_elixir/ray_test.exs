defmodule RayTracerElixir.RayTest do
  use ExUnit.Case, async: true

  alias RayTracerElixir.Vector
  alias RayTracerElixir.Point
  alias RayTracerElixir.Ray

  test "creating and querying a ray" do
    origin = Point.new(1, 2, 3)
    direction = Vector.new(4, 5, 6)
    r = Ray.new(origin, direction)

    assert r.origin == origin
    assert r.direction == direction
  end

  test "computing a point from a distance" do
    r = Ray.new(Point.new(2, 3, 4), Vector.new(1, 0, 0))

    assert Ray.position(r, 0) == Point.new(2, 3, 4)
    assert Ray.position(r, 1) == Point.new(3, 3, 4)
    assert Ray.position(r, -1) == Point.new(1, 3, 4)
    assert Ray.position(r, 2.5) == Point.new(4.5, 3, 4)
  end
end
