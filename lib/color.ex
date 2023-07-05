defmodule RayTracerElixir.Color do
  @behaviour RayTracerElixir.Components

  use RayTracerElixir.ComponentOperations

  defstruct [:red, :green, :blue]

  @impl RayTracerElixir.Components
  def new([red, green, blue]) do
    new(red, green, blue)
  end

  @spec new(any, any, any) :: %RayTracerElixir.Color{blue: any, green: any, red: any}
  def new(red, green, blue) do
    %__MODULE__{red: red, green: green, blue: blue}
  end

  @impl RayTracerElixir.Components
  def components(color) do
    [color.red, color.green, color.blue]
  end

  def multiply(c1, c2) when is_struct(c2) do
    zip_components(c1, c2, &Kernel.*/2) |> new()
  end
end
