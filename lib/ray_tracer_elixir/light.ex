defmodule RayTracerElixir.Light do
  def point_light(position, intensity) do
    %{position: position, intensity: intensity}
  end
end
