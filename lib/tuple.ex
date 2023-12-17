defmodule RayTracerElixir.Tuple do
  def new(x, y, z, w) do
    %{x: x, y: y, z: z, w: w}
  end

  def new([x, y, z, w]) do
    new(x, y, z, w)
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

  def magnitude(vector) do
    Components.map_components(vector, fn c -> :math.pow(c, 2) end)
    |> Components.reduce_components(&Kernel.+/2)
    |> :math.sqrt()
  end

  def normalize(vector) do
    Components.divide(vector, magnitude(vector))
  end

  def dot(a, b) do
    Components.zip_components(a, b, &Kernel.*/2) |> Enum.sum()
  end

  def cross(a, b) do
    new_vector(
      a.y * b.z - a.z * b.y,
      a.z * b.x - a.x * b.z,
      a.x * b.y - a.y * b.x
    )
  end
end
