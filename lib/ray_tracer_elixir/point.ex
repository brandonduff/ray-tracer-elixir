defmodule RayTracerElixir.Point do
  def new(x, y, z) do
    %{x: x, y: y, z: z, w: 1}
  end
end
