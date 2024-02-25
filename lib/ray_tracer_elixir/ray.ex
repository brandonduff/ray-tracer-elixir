defmodule RayTracerElixir.Ray do
  alias RayTracerElixir.Matrix
  alias RayTracerElixir.Tuple

  def new(origin, direction) do
    %{origin: origin, direction: direction}
  end

  def position(ray, distance) do
    Tuple.add(ray.origin, Tuple.multiply(ray.direction, distance))
  end

  def transform(ray, matrix) do
    new(Matrix.multiply(matrix, ray.origin), Matrix.multiply(matrix, ray.direction))
  end
end
