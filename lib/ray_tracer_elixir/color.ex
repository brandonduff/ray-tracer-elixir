defmodule RayTracerElixir.Color do
  alias RayTracerElixir.Tuple

  defstruct [:red, :green, :blue]

  def new(red, green, blue) do
    %__MODULE__{red: red, green: green, blue: blue}
  end

  def scale(color, scale) do
    Tuple.map_components(color, fn component ->
      scaled = component * scale
      cond do
        scaled > scale -> scale
        scaled < 0 -> 0
        true -> scaled
      end
      |> round()
    end)
  end
end
