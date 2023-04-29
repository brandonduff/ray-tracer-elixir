defmodule RayTracerElixirTest do
  use ExUnit.Case
  doctest RayTracerElixir

  test "creating a tuple" do
    result = RayTracerElixir.tuple(5, 6, 7, 8)
    assert result.x == 5
    assert result.y == 6
    assert result.z == 7
    assert result.w == 8
  end
end
