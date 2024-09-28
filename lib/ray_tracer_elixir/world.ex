defmodule RayTracerElixir.World do
  alias RayTracerElixir.Material
  alias RayTracerElixir.Matrix
  alias RayTracerElixir.Sphere
  alias RayTracerElixir.Point
  alias RayTracerElixir.Color
  alias RayTracerElixir.Light

  def new(opts \\ []) do
    %{light_source: nil, objects: []}
    |> Map.merge(Map.new(opts))
  end

  def default do
    result =
      new(light_source: Light.point_light(Point.new(-10, 10, -10), Color.new(1, 1, 1)))

    s1 =
      Sphere.new()
      |> Map.put(
        :material,
        Material.new(color: Color.new(0.8, 1.0, 0.6), diffuse: 0.7, specular: 0.2)
      )

    s2 = Sphere.new(transform: Matrix.scaling(0.5, 0.5, 0.5))
    Map.put(result, :objects, [s1, s2])
  end
end
