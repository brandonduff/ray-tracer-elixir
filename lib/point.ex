defmodule RayTracerElixir.Point do
  alias RayTracerElixir.Tuple

  def new(x, y, z) do
    %{x: x, y: y, z: z, w: 1}
  end
end