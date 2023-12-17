defmodule Components do
  alias RayTracerElixir.Color
  alias RayTracerElixir.ComponentOperations

  def new([red, green, blue]) do
    new(red, green, blue)
  end

  def new([x, y, z, w]) do
    new(x, y, z, w)
  end

  @spec new(any, any, any) :: %RayTracerElixir.Color{blue: any, green: any, red: any}
  def new(red, green, blue) do
    %Color{red: red, green: green, blue: blue}
  end

  def new(x, y, z, w) do
    %{x: x, y: y, z: z, w: w}
  end

  def zip_components(a, b, func) do
    Enum.zip_with(to_components(a), to_components(b), func)
  end

  def add(a, b) do
    Components.zip_components(a, b, &Kernel.+/2) |> new()
  end

  def subtract(a, b) do
    zip_components(a, b, &Kernel.-/2) |> new()
  end

  def negate(tuple) do
    subtract(new([0, 0, 0, 0]), tuple)
  end

  def multiply(tuple, scalar) when is_number(scalar) do
    map_components(tuple, fn c -> c * scalar end)
  end

  def multiply(c1, c2) when is_struct(c2) do
    zip_components(c1, c2, &Kernel.*/2) |> new()
  end

  def divide(tuple, scalar) do
    map_components(tuple, fn c -> c / scalar end)
  end

  def equal?(a, b) do
    zip_components(a, b, fn c1, c2 -> ComponentOperations.close?(c1, c2) end) |> Enum.all?()
  end

  def magnitude(vector) do
    map_components(vector, fn c -> :math.pow(c, 2) end)
    |> reduce_components(&Kernel.+/2)
    |> :math.sqrt()
  end

  def reduce_components(tuple, func) do
    Enum.reduce(to_components(tuple), func)
  end

  def map_components(tuple, func) do
    apply(__MODULE__, :new, Enum.map(to_components(tuple), func))
  end

  def to_components(%{x: x, y: y, z: z, w: w}) do
    [x, y, z, w]
  end

  def to_components(%{red: red, green: green, blue: blue}) do
    [red, green, blue]
  end
end
