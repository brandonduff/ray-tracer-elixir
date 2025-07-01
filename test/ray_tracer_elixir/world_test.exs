defmodule RayTracerElixir.WorldTest do
  use ExUnit.Case, async: true

  alias RayTracerElixir.Tuple
  alias RayTracerElixir.Intersection
  alias RayTracerElixir.Vector
  alias RayTracerElixir.Ray
  alias RayTracerElixir.Matrix
  alias RayTracerElixir.Material
  alias RayTracerElixir.Sphere
  alias RayTracerElixir.Color
  alias RayTracerElixir.Point
  alias RayTracerElixir.Light
  alias RayTracerElixir.World

  test "Creating a world" do
    w = World.new()
    assert Enum.empty?(w.objects)
    assert nil == w.light
  end

  test "The default world" do
    light = Light.point_light(Point.new(-10, 10, -10), Color.new(1, 1, 1))

    s1 =
      Sphere.new()
      |> Map.put(
        :material,
        Material.new()
        |> Map.put(:color, Color.new(0.8, 1.0, 0.6))
        |> Map.put(:diffuse, 0.7)
        |> Map.put(:specular, 0.2)
      )

    s2 = Sphere.new() |> Sphere.set_transform(Matrix.scaling(0.5, 0.5, 0.5))

    w = World.default()

    assert w.light == light
    assert Enum.member?(w.objects, s1)
    assert Enum.member?(w.objects, s2)
  end

  test "Intersect a world with a ray" do
    w = World.default()
    r = Ray.new(Point.new(0, 0, -5), Vector.new(0, 0, 1))

    xs = World.intersect(w, r)

    assert Enum.count(xs) == 4
    assert Enum.map(xs, fn x -> x.t end) == [4, 4.5, 5.5, 6]
  end

  test "Shading an intersection" do
    w = World.default()
    r = Ray.new(Point.new(0, 0, -5), Vector.new(0, 0, 1))
    shape = hd(w.objects)
    i = Intersection.new(4, shape)

    comps = Intersection.prepare_computations(i, r)
    c = World.shade_hit(w, comps)

    assert Tuple.equal?(c, Color.new(0.38066, 0.47583, 0.2855))
  end

  test "Shading an intersection from the inside" do
    w = %{
      World.default()
      | light: Light.point_light(Point.new(0, 0.25, 0), Color.new(1, 1, 1))
    }

    r = Ray.new(Point.new(0, 0, 0), Vector.new(0, 0, 1))
    shape = Enum.at(w.objects, 1)
    i = Intersection.new(0.5, shape)

    comps = Intersection.prepare_computations(i, r)
    c = World.shade_hit(w, comps)

    assert Tuple.equal?(c, Color.new(0.1, 0.1, 0.1))
  end

  test "The color when a ray misses" do
    w = World.default()
    r = Ray.new(Point.new(0, 0, -5), Vector.new(0, 1, 0))

    c = World.color_at(w, r)

    assert Tuple.equal?(c, Color.new(0, 0, 0))
  end

  test "The color when a ray hits" do
    w = World.default()
    r = Ray.new(Point.new(0, 0, -5), Vector.new(0, 0, 1))

    c = World.color_at(w, r)

    assert Tuple.equal?(c, Color.new(0.38066, 0.47583, 0.2855))
  end

  test "The color with an intersection behind the ray" do
    w =
      World.default()
      |> put_in([:objects, Access.at(0), :material, :ambient], 1)
      |> put_in([:objects, Access.at(1), :material, :ambient], 1)

    r = Ray.new(Point.new(0, 0, 0.75), Vector.new(0, 0, -1))

    c = World.color_at(w, r)
    assert Tuple.equal?(c, get_in(w, [:objects, Access.at(1), :material, :color]))
  end

  test "There is no shadow when nothing is colinear with point and light" do
    w = World.default()
    p = Point.new(0, 10, 0)
    refute World.shadowed?(w, p)
  end

  test "The shadow when an object is between the point and the light" do
    w = World.default()
    p = Point.new(10, -10, 10)
    assert World.shadowed?(w, p)
  end

  test "There is no shadow when an object is behind the point" do
    w = World.default()
    p = Point.new(-2, 2, -2)
    refute World.shadowed?(w, p)
  end

  test "shade_hit/2 is given an intersection in shadow" do
    w =
      World.new()
      |> put_in([:light], Light.point_light(Point.new(0, 0, -10), Color.new(1, 1, 1)))

    s1 = Sphere.new()
    s2 = Sphere.new() |> Sphere.set_transform(Matrix.translation(0, 0, 10))
    w = w |> World.add_object(s1) |> World.add_object(s2)

    r = Ray.new(Point.new(0, 0, 5), Vector.new(0, 0, 1))
    i = Intersection.new(4, s2)

    comps = Intersection.prepare_computations(i, r)
    c = World.shade_hit(w, comps)

    assert Tuple.equal?(c, Color.new(0.1, 0.1, 0.1))
  end
end
