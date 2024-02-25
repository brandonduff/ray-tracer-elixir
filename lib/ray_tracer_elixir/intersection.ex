defmodule RayTracerElixir.Intersection do
  defstruct [:t, :object]

  def new(t, object) do
    %__MODULE__{t: t, object: object}
  end

  def aggregate(i1, i2) do
    [i1, i2]
  end

  def intersections(list) do
    list
  end

  def hit(intersections) do
    intersections
    |> Enum.filter(fn intersection -> intersection.t > 0 end)
    |> Enum.min_by(fn intersection -> intersection.t end, fn -> nil end)
  end
end
