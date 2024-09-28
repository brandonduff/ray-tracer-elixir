defmodule RayTracerElixir.WorldTest do
  use ExUnit.Case, async: true

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
    assert nil == w.light_source
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

    assert w.light_source == light
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
end
