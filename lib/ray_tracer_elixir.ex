defmodule RayTracerElixir do
  def tuple(x, y, z, w) do
    %{x: x, y: y, z: z, w: w}
  end

  def point(x, y, z) do
    %{x: x, y: y, z: z, w: 1.0}
  end

  def vector(x, y, z) do
    %{x: x, y: y, z: z, w: 0}
  end

  def point?(tuple) do
    tuple.w == 1.0
  end

  def vector?(tuple) do
    tuple.w == 0
  end

  def add(a, b) do
    tuple(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w)
  end

  def subtract(a, b) do
    tuple(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w)
  end

  def negate(tuple) do
    subtract(tuple(0, 0, 0, 0), tuple)
  end

  def equal?(a, b) do
    close?(a.x, b.x) && close?(a.y, b.y) && close?(a.z, b.z) && close?(a.w, b.w)
  end

  defp close?(a, b) do
    abs(a - b) < 0.00001
  end
end
