defmodule RayTracerElixir.Intersection do
  defstruct [:t, :object]

  def new(t, object) do
    %__MODULE__{t: t, object: object}
  end

  def aggregate(i1, i2) do
    [i1, i2]
  end
end
