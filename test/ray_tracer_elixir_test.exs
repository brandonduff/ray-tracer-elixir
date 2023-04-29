defmodule RayTracerElixirTest do
  use ExUnit.Case
  doctest RayTracerElixir

  test "greets the world" do
    assert RayTracerElixir.hello() == :world
  end

  test "creating a tuple" do
    result = RayTracerElixir.tuple(5, 6, 7, 8)
    assert result.x == 5
  end
end
