defmodule RayTracerElixir.Color do
  defstruct [:red, :green, :blue]

  def new([red, green, blue]) do
    new(red, green, blue)
  end

  @spec new(any, any, any) :: %RayTracerElixir.Color{blue: any, green: any, red: any}
  def new(red, green, blue) do
    %__MODULE__{red: red, green: green, blue: blue}
  end
end
