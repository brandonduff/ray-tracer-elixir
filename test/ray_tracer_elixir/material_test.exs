defmodule RayTracerElixir.MaterialTest do
  use ExUnit.Case, async: true

  alias RayTracerElixir.Light
  alias RayTracerElixir.Point
  alias RayTracerElixir.Vector
  alias RayTracerElixir.Material
  alias RayTracerElixir.Color
  alias RayTracerElixir.Tuple

  test "The default material" do
    m = Material.new()

    assert Tuple.equal?(m.color, Color.new(1, 1, 1))
    assert m.ambient == 0.1
    assert m.diffuse == 0.9
    assert m.specular == 0.9
    assert m.shininess == 200.0
  end

  describe "lighting" do
    setup do
      %{m: Material.new(), position: Point.new(0, 0, 0)}
    end

    test "Lighting with the eye between the light and the surface", %{m: m, position: position} do
      eyev = normalv = Vector.new(0, 0, -1)
      light = Light.point_light(Point.new(0, 0, -10), Color.new(1, 1, 1))

      result = Material.lighting(m, light, position, eyev, normalv)

      assert Tuple.equal?(result, Color.new(1.9, 1.9, 1.9))
    end

    test "Lighting with the eye between light and surface, eye offset 45°", %{
      m: m,
      position: position
    } do
      eyev = Vector.new(0, :math.sqrt(2) / 2, -:math.sqrt(2) / 2)
      normalv = Vector.new(0, 0, -1)
      light = Light.point_light(Point.new(0, 0, -10), Color.new(1, 1, 1))

      result = Material.lighting(m, light, position, eyev, normalv)

      # Ambient and diffuse are unchanged from default, specular has
      # fallen off to 0
      assert Tuple.equal?(result, Color.new(1.0, 1.0, 1.0))
    end

    test "Lighting with eye opposite surface, light offset 45°", %{m: m, position: position} do
      eyev = normalv = Vector.new(0, 0, -1)
      light = Light.point_light(Point.new(0, 10, -10), Color.new(1, 1, 1))

      result = Material.lighting(m, light, position, eyev, normalv)

      # Diffuse component becomes 0.9 * √2/2, specular falls off
      assert Tuple.equal?(result, Color.new(0.7364, 0.7364, 0.7364))
    end

    test "Lighting with eye in the path of the reflection vector", %{m: m, position: position} do
      eyev = Vector.new(0, -:math.sqrt(2) / 2, -:math.sqrt(2) / 2)

      normalv = Vector.new(0, 0, -1)
      light = Light.point_light(Point.new(0, 10, -10), Color.new(1, 1, 1))

      result = Material.lighting(m, light, position, eyev, normalv)

      # Specular at full strength, ambient and diffuse same as
      # previous test. So 0.1 + 0.9 * √2/2 + 0.9
      assert Tuple.equal?(result, Color.new(1.6364, 1.6364, 1.6364))
    end

    test "Lighting with the light behind the surface", %{m: m, position: position} do
      eyev = Vector.new(0, 0, -1)
      normalv = Vector.new(0, 0, -1)
      light = Light.point_light(Point.new(0, 0, 10), Color.new(1, 1, 1))

      result = Material.lighting(m, light, position, eyev, normalv)

      # Since the light is not shining on the object, we just see
      # ambient light
      assert Tuple.equal?(result, Color.new(0.1, 0.1, 0.1))
    end

    test "Lighting with the surface in shadow", %{m: m, position: position} do
      eyev = Vector.new(0, 0, -1)
      normalv = Vector.new(0, 0, -1)
      light = Light.point_light(Point.new(0, 0, -10), Color.new(1, 1, 1))
      in_shadow = true

      result = Material.lighting(m, light, position, eyev, normalv, in_shadow)

      assert Tuple.equal?(result, Color.new(0.1, 0.1, 0.1))
    end
  end
end
