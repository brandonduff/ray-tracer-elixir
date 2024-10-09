defmodule RayTracerElixir.Numbers do
  def close?(a, b) do
    abs(a - b) < epsilon()
  end

  def epsilon do
    0.00001
  end
end
