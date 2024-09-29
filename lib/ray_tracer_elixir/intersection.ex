defmodule RayTracerElixir.Intersection do
  alias RayTracerElixir.Vector
  alias RayTracerElixir.Sphere
  alias RayTracerElixir.Tuple
  alias RayTracerElixir.Ray

  defstruct [:t, :object]

  def new(t, object) do
    %__MODULE__{t: t, object: object}
  end

  def aggregate(i1, i2) do
    [i1, i2]
  end

  def intersections(list) do
    list
  end

  def hit(intersections) do
    intersections
    |> Enum.filter(fn intersection -> intersection.t > 0 end)
    |> Enum.min_by(fn intersection -> intersection.t end, fn -> nil end)
  end

  def prepare_computations(intersection, ray) do
    result = %{
      t: intersection.t,
      object: intersection.object,
      point: Ray.position(ray, intersection.t),
      eyev: Tuple.negate(ray.direction),
      inside: nil,
      normalv: nil
    }

    result
    |> compute_normalv()
    |> compute_inside()
  end

  defp compute_normalv(result) do
    %{result | normalv: Sphere.normal_at(result.object, result.point)}
  end

  defp compute_inside(comps) do
    if Vector.dot(comps.normalv, comps.eyev) < 0 do
      %{comps | inside: true, normalv: Tuple.negate(comps.normalv)}
    else
      %{comps | inside: false}
    end
  end
end
