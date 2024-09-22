defmodule RayTracerElixir.LightTest do
  alias RayTracerElixir.Light
  alias RayTracerElixir.Tuple
  alias RayTracerElixir.Point
  alias RayTracerElixir.Color
  use ExUnit.Case, async: true

  test "A point light has a position and intensity" do
    intensity = Color.new(1, 1, 1)
    position = Point.new(0, 0, 0)

    light = Light.point_light(position, intensity)

    assert Tuple.equal?(light.position, position)
    assert Tuple.equal?(light.intensity, intensity)
  end
end
