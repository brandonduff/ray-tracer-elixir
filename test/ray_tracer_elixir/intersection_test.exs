defmodule RayTracerElixir.IntersectionTest do
  use ExUnit.Case, async: true

  alias RayTracerElixir.Numbers
  alias RayTracerElixir.Matrix
  alias RayTracerElixir.Ray
  alias RayTracerElixir.Vector
  alias RayTracerElixir.Point
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

  test "hit when all intersections have positive t" do
    s = Sphere.new()
    i1 = Intersection.new(1, s)
    i2 = Intersection.new(2, s)
    xs = Intersection.intersections([i2, i1])

    i = Intersection.hit(xs)

    assert i == i1
  end

  test "hit when some intersections have negative t" do
    s = Sphere.new()
    i1 = Intersection.new(-1, s)
    i2 = Intersection.new(2, s)
    xs = Intersection.intersections([i2, i1])

    i = Intersection.hit(xs)

    assert i == i2
  end

  test "hit when all intersections have negative t" do
    s = Sphere.new()
    i1 = Intersection.new(-1, s)
    i2 = Intersection.new(-2, s)
    xs = Intersection.intersections([i2, i1])

    i = Intersection.hit(xs)

    assert i == nil
  end

  test "hit is always the lowest non-negative is_integer" do
    s = Sphere.new()
    i1 = Intersection.new(5, s)
    i2 = Intersection.new(7, s)
    i3 = Intersection.new(-3, s)
    i4 = Intersection.new(2, s)
    xs = Intersection.intersections([i1, i2, i3, i4])

    i = Intersection.hit(xs)

    assert i == i4
  end

  test "Precomputing the state of an intersection" do
    r = Ray.new(Point.new(0, 0, -5), Vector.new(0, 0, 1))
    shape = Sphere.new()
    i = Intersection.new(4, shape)

    comps = Intersection.prepare_computations(i, r)

    assert comps.t == i.t
    assert comps.object == i.object
    assert comps.point == Point.new(0, 0, -1)
    assert comps.eyev == Vector.new(0, 0, -1)
    assert comps.normalv == Vector.new(0, 0, -1)
  end

  test "The hit, when an intersection occurs on the outside" do
    r = Ray.new(Point.new(0, 0, -5), Vector.new(0, 0, 1))
    shape = Sphere.new()
    i = Intersection.new(4, shape)

    comps = Intersection.prepare_computations(i, r)

    refute comps.inside
  end

  test "The hit, when an intersection occurs on the inside" do
    r = Ray.new(Point.new(0, 0, 0), Vector.new(0, 0, 1))
    shape = Sphere.new()
    i = Intersection.new(1, shape)

    comps = Intersection.prepare_computations(i, r)

    assert comps.point == Point.new(0, 0, 1)
    assert comps.eyev == Vector.new(0, 0, -1)
    assert comps.inside
    assert comps.normalv == Vector.new(0, 0, -1)
  end

  test "The hit should offset the point" do
    r = Ray.new(Point.new(0, 0, -5), Vector.new(0, 0, 1))
    shape = Sphere.new() |> Sphere.set_transform(Matrix.translation(0, 0, 1))
    i = Intersection.new(5, shape)

    comps = Intersection.prepare_computations(i, r)

    assert comps.over_point.z < -Numbers.epsilon() / 2
    assert comps.point.z > comps.over_point.z
  end
end
