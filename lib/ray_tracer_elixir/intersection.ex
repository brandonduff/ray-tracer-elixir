defmodule RayTracerElixir.Intersection do
  alias RayTracerElixir.Numbers
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
      normalv: nil,
      over_point: nil
    }

    result
    |> compute_normalv()
    |> compute_over_point()
    |> compute_inside()
  end

  defp compute_over_point(result) do
    %{
      result
      | over_point: Tuple.add(result.point, Tuple.multiply(result.normalv, Numbers.epsilon()))
    }
  end

  defp compute_normalv(result) do
    %{result | normalv: Sphere.normal_at(result.object, result.point)}
  end

  defp compute_inside(result) do
    if Vector.dot(result.normalv, result.eyev) < 0 do
      %{result | inside: true, normalv: Tuple.negate(result.normalv)}
    else
      %{result | inside: false}
    end
  end
end
