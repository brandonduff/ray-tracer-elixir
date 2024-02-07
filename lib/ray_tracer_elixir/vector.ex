defmodule RayTracerElixir.Vector do
  alias RayTracerElixir.Tuple

  def new(x, y, z) do
    %{x: x, y: y, z: z, w: 0}
  end

  def new([x, y, z]) do
    new(x, y, z)
  end

  def magnitude(vector) do
    Tuple.map_components(vector, fn c -> :math.pow(c, 2) end)
    |> Tuple.reduce_components(&Kernel.+/2)
    |> :math.sqrt()
  end

  def normalize(vector) do
    Tuple.divide(vector, magnitude(vector))
  end

  def dot(a, b) do
    Tuple.zip_components(a, b, &Kernel.*/2) |> Enum.sum()
  end

  def cross(a, b) do
    new(
      a.y * b.z - a.z * b.y,
      a.z * b.x - a.x * b.z,
      a.x * b.y - a.y * b.x
    )
  end
end