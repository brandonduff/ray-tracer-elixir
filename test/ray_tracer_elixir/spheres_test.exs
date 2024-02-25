defmodule RayTracerElixir.SpheresTest do
  use ExUnit.Case, async: true

  alias RayTracerElixir.Matrix
  alias RayTracerElixir.Sphere
  alias RayTracerElixir.Vector
  alias RayTracerElixir.Point
  alias RayTracerElixir.Ray

  test "a ray intersects a sphere at two points" do
    r = Ray.new(Point.new(0, 0, -5), Vector.new(0, 0, 1))
    s = Sphere.new()

    xs = Sphere.intersect(s, r)

    assert Enum.count(xs) == 2
    assert Enum.at(xs, 0).t == 4.0
    assert Enum.at(xs, 1).t == 6.0
  end

  test "a ray intersects a sphere at a tangent" do
    r = Ray.new(Point.new(0, 1, -5), Vector.new(0, 0, 1))
    s = Sphere.new()

    xs = Sphere.intersect(s, r)

    assert Enum.count(xs) == 2
    assert Enum.at(xs, 0).t == 5.0
    assert Enum.at(xs, 1).t == 5.0
  end

  test "a ray misses a sphere" do
    r = Ray.new(Point.new(0, 2, -5), Vector.new(0, 0, 1))
    s = Sphere.new()

    xs = Sphere.intersect(s, r)

    assert Enum.count(xs) == 0
  end

  test "a ray originates inside a sphere" do
    r = Ray.new(Point.new(0, 0, 0), Vector.new(0, 0, 1))
    s = Sphere.new()

    xs = Sphere.intersect(s, r)

    assert Enum.count(xs) == 2
    assert Enum.at(xs, 0).t == -1.0
    assert Enum.at(xs, 1).t == 1.0
  end

  test "a sphere is behind a ray" do
    r = Ray.new(Point.new(0, 0, 5), Vector.new(0, 0, 1))
    s = Sphere.new()

    xs = Sphere.intersect(s, r)

    assert Enum.count(xs) == 2
    assert Enum.at(xs, 0).t == -6.0
    assert Enum.at(xs, 1).t == -4.0
  end

  test "intersect sets the object of the intersection" do
    r = Ray.new(Point.new(0, 0, -5), Vector.new(0, 0, 1))
    s = Sphere.new()

    xs = Sphere.intersect(s, r)

    assert Enum.count(xs) == 2
    assert Enum.at(xs, 0).object == s
    assert Enum.at(xs, 1).object == s
  end

  test "a sphere's default transformation" do
    s = Sphere.new()
    assert s.transform == Matrix.identity_matrix()
  end

  test "changing a sphere's transformation" do
    s = Sphere.new()
    t = Matrix.translation(2, 3, 4)
    s = Sphere.set_transform(s, t)
    assert s.transform == t
  end

  test "intersecting a scaled sphere with a ray" do
    r = Ray.new(Point.new(0, 0, -5), Vector.new(0, 0, 1))
    s = Sphere.new()

    s = Sphere.set_transform(s, Matrix.scaling(2, 2, 2))
    xs = Sphere.intersect(s, r)

    assert Enum.count(xs) == 2
    assert Enum.at(xs, 0).t == 3
    assert Enum.at(xs, 1).t == 7
  end

  test "intersecting a translated sphere with a ray" do
    r = Ray.new(Point.new(0, 0, -5), Vector.new(0, 0, 1))
    s = Sphere.new()

    s = Sphere.set_transform(s, Matrix.translation(5, 0, 0))
    xs = Sphere.intersect(s, r)

    assert Enum.count(xs) == 0
  end
end
