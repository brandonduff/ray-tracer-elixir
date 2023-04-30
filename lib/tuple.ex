defmodule RayTracerElixir.Tuple do
  def new(x, y, z, w) do
    %{x: x, y: y, z: z, w: w}
  end

  def new_point(x, y, z) do
    new(x, y, z, 1)
  end

  def new_vector(x, y, z) do
    new(x, y, z, 0)
  end

  def point?(tuple) do
    tuple.w == 1.0
  end

  def vector?(tuple) do
    tuple.w == 0
  end

  def add(a, b) do
    new(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w)
  end

  def subtract(a, b) do
    new(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w)
  end

  def negate(tuple) do
    subtract(new(0, 0, 0, 0), tuple)
  end

  def multiply(tuple, scalar) do
    new(tuple.x * scalar, tuple.y * scalar, tuple.z * scalar, tuple.w * scalar)
  end

  def equal?(a, b) do
    close?(a.x, b.x) && close?(a.y, b.y) && close?(a.z, b.z) && close?(a.w, b.w)
  end

  defp close?(a, b) do
    abs(a - b) < 0.00001
  end
end
