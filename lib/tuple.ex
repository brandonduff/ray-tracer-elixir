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

  def add(a, b) do
    zip_components(a, b, &Kernel.+/2) |> new()
  end

  def subtract(a, b) do
    zip_components(a, b, &Kernel.-/2) |> new()
  end

  def negate(tuple) do
    subtract(new(0, 0, 0, 0), tuple)
  end

  def multiply(tuple, scalar) do
    map_components(tuple, fn c -> c * scalar end)
  end

  def divide(tuple, scalar) do
    map_components(tuple, fn c -> c / scalar end)
  end

  def magnitude(vector) do
    map_components(vector, fn c -> :math.pow(c, 2) end)
    |> reduce_components(&Kernel.+/2)
    |> :math.sqrt()
  end

  def normalize(vector) do
    divide(vector, magnitude(vector))
  end

  def dot(a, b) do
    zip_components(a, b, &Kernel.*/2) |> Enum.sum()
  end

  def equal?(a, b) do
    zip_components(a, b, fn c1, c2 -> close?(c1, c2) end) |> Enum.all?()
  end

  defp close?(a, b) do
    abs(a - b) < 0.00001
  end

  defp map_components(tuple, func) do
    apply(__MODULE__, :new, Enum.map(components(tuple), func))
  end

  defp zip_components(a, b, func) do
    Enum.zip_with(components(a), components(b), func)
  end

  defp reduce_components(tuple, func) do
    Enum.reduce(components(tuple), func)
  end

  defp components(tuple) do
    [tuple.x, tuple.y, tuple.z, tuple.w]
  end
end
