defmodule RayTracerElixir.World do
  alias RayTracerElixir.Ray
  alias RayTracerElixir.Vector
  alias RayTracerElixir.Tuple
  alias RayTracerElixir.Intersection
  alias RayTracerElixir.Material
  alias RayTracerElixir.Matrix
  alias RayTracerElixir.Sphere
  alias RayTracerElixir.Point
  alias RayTracerElixir.Color
  alias RayTracerElixir.Light

  def new(opts \\ []) do
    %{light: nil, objects: []}
    |> Map.merge(Map.new(opts))
  end

  def default do
    s1 =
      Sphere.new()
      |> Map.put(
        :material,
        Material.new(color: Color.new(0.8, 1.0, 0.6), diffuse: 0.7, specular: 0.2)
      )

    s2 = Sphere.new(transform: Matrix.scaling(0.5, 0.5, 0.5))

    new(light: Light.point_light(Point.new(-10, 10, -10), Color.new(1, 1, 1)))
    |> add_objects([s1, s2])
  end

  def add_objects(world, objects) do
    Enum.reduce(objects, world, &add_object(&2, &1))
  end

  def add_object(world, object) do
    Map.put(world, :objects, world.objects ++ [object])
  end

  def intersect(world, ray) do
    Enum.flat_map(world.objects, fn object ->
      Sphere.intersect(object, ray)
    end)
    |> Enum.sort_by(fn intersection -> intersection.t end)
  end

  def shade_hit(world, comps) do
    Material.lighting(
      comps.object.material,
      world.light,
      comps.over_point,
      comps.eyev,
      comps.normalv,
      shadowed?(world, comps.over_point)
    )
  end

  def color_at(world, ray) do
    if hit = Intersection.hit(intersect(world, ray)) do
      comps = Intersection.prepare_computations(hit, ray)
      shade_hit(world, comps)
    else
      Color.new(0, 0, 0)
    end
  end

  def shadowed?(world, point) do
    v = Tuple.subtract(world.light.position, point)
    distance = Vector.magnitude(v)
    direction = Vector.normalize(v)

    r = Ray.new(point, direction)
    intersections = intersect(world, r)

    h = Intersection.hit(intersections)

    h && h.t < distance
  end
end
