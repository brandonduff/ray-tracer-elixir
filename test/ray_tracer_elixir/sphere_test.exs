defmodule RayTracerElixir.SphereTest do
  use ExUnit.Case, async: true

  alias RayTracerElixir.Material
  alias RayTracerElixir.Matrix
  alias RayTracerElixir.Sphere
  alias RayTracerElixir.Vector
  alias RayTracerElixir.Point
  alias RayTracerElixir.Ray
  alias RayTracerElixir.Tuple

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

  describe "normal" do
    test "The normal on a sphere at a point on the x axis" do
      s = Sphere.new()
      n = Sphere.normal_at(s, Point.new(1, 0, 0))
      assert Tuple.equal?(n, Vector.new(1, 0, 0))
    end

    test "The normal on a sphere at a point on the y axis" do
      s = Sphere.new()
      n = Sphere.normal_at(s, Point.new(0, 1, 0))
      assert Tuple.equal?(n, Vector.new(0, 1, 0))
    end

    test "The normal on a sphere at a point on the z axis" do
      s = Sphere.new()
      n = Sphere.normal_at(s, Point.new(0, 0, 1))
      assert Tuple.equal?(n, Vector.new(0, 0, 1))
    end

    test "The normal on a sphere on a nonaxial point" do
      s = Sphere.new()
      n = Sphere.normal_at(s, Point.new(:math.sqrt(3) / 3, :math.sqrt(3) / 3, :math.sqrt(3) / 3))
      assert Tuple.equal?(n, Vector.new(:math.sqrt(3) / 3, :math.sqrt(3) / 3, :math.sqrt(3) / 3))
    end

    test "The normal is a normalized vector" do
      s = Sphere.new()
      n = Sphere.normal_at(s, Point.new(:math.sqrt(3) / 3, :math.sqrt(3) / 3, :math.sqrt(3) / 3))
      assert Tuple.equal?(n, Vector.normalize(n))
    end

    test "Computing the normal on a translated sphere" do
      s =
        Sphere.new()
        |> Sphere.set_transform(Matrix.translation(0, 1, 0))

      n = Sphere.normal_at(s, Point.new(0, 1.70711, -0.70711))

      assert Tuple.equal?(n, Vector.new(0, 0.70711, -0.70711))
    end

    test "Computing the normal on a transformed sphere" do
      m = Matrix.scaling(1, 0.5, 1) |> Matrix.multiply(Matrix.rotation_z(:math.pi() / 5))
      s = Sphere.set_transform(Sphere.new(), m)

      n = Sphere.normal_at(s, Point.new(0, :math.sqrt(2) / 2, -:math.sqrt(2) / 2))

      assert Tuple.equal?(n, Vector.new(0, 0.97014, -0.24254))
    end
  end

  test "A sphere has a default material" do
    s = Sphere.new()
    m = s.material
    assert m == Material.new()
  end

  test "A sphere may be assigned a material" do
    s = Sphere.new()
    m = Material.new()
    m = %{m | ambient: 1}

    s = %{s | material: m}

    assert s.material == m
  end
end
