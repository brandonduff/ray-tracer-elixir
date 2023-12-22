defmodule RayTracerElixir.Color do
  defstruct [:red, :green, :blue]

  @spec new(any, any, any) :: %RayTracerElixir.Color{blue: any, green: any, red: any}
  def new(red, green, blue) do
    %__MODULE__{red: red, green: green, blue: blue}
  end
end
