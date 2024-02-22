defmodule RayTracerElixir.IntersectionTest do
  use ExUnit.Case, async: true

  alias RayTracerElixir.Sphere
  alias RayTracerElixir.Intersection

  test "an intersection encapsulates t and object" do
    s = Sphere.new()
    i = Intersection.new(3.5, s)

    assert i.t == 3.5
    assert i.object == s
  end

  test "aggregating intersections" do
    s = Sphere.new()
    i1 = Intersection.new(1, s)
    i2 = Intersection.new(2, s)

    xs = Intersection.aggregate(i1, i2)

    assert Enum.count(xs) == 2
    assert Enum.at(xs, 0).t == 1
    assert Enum.at(xs, 1).t == 2
  end
end
