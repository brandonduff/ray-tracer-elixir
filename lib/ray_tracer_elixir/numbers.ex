defmodule RayTracerElixir.Numbers do
  def close?(a, b) do
    abs(a - b) < 0.00001
  end
end
