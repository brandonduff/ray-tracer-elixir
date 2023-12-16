defmodule RayTracerElixir.ComponentOperations do
  def close?(a, b) do
    abs(a - b) < 0.00001
  end
end
