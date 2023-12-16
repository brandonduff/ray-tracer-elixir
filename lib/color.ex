defmodule RayTracerElixir.Color do
  alias RayTracerElixir.ComponentOperations

  def add(a, b) do
    zip_components(a, b, &Kernel.+/2) |> new()
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

  defp map_components(tuple, func) do
    apply(__MODULE__, :new, Enum.map(components(tuple), func))
  end

  defp zip_components(a, b, func) do
    Enum.zip_with(components(a), components(b), func)
  end

  defstruct [:red, :green, :blue]

  def new([red, green, blue]) do
    new(red, green, blue)
  end

  @spec new(any, any, any) :: %RayTracerElixir.Color{blue: any, green: any, red: any}
  def new(red, green, blue) do
    %__MODULE__{red: red, green: green, blue: blue}
  end

  def components(color) do
    [color.red, color.green, color.blue]
  end
end
