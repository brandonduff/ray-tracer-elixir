defmodule RayTracerElixir.Ray do
  alias RayTracerElixir.Tuple

  def new(origin, direction) do
    %{origin: origin, direction: direction}
  end

  def position(ray, distance) do
    Tuple.add(ray.origin, Tuple.multiply(ray.direction, distance))
  end
end
