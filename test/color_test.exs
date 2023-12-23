defmodule RayTracerElixir.ColorTest do
  use ExUnit.Case
  alias RayTracerElixir.Color
  alias RayTracerElixir.Tuple

  test "colors are red, green, and blue tuples" do
    c = Color.new(-0.5, 0.4, 1.7)
    assert c.red == -0.5
    assert c.green == 0.4
    assert c.blue == 1.7
  end

  test "adding colors" do
    c1 = Color.new(0.9, 0.6, 0.75)
    c2 = Color.new(0.7, 0.1, 0.25)
    assert Tuple.equal?(Tuple.add(c1, c2), Tuple.new(1.6, 0.7, 1.0))
  end

  test "subtracting colors" do
    c1 = Color.new(0.9, 0.6, 0.75)
    c2 = Color.new(0.7, 0.1, 0.25)
    assert Tuple.equal?(Tuple.subtract(c1, c2), Tuple.new(0.2, 0.5, 0.5))
  end

  test "multiplying a color by a scalar" do
    c = Color.new(0.2, 0.3, 0.4)
    assert Tuple.equal?(Tuple.multiply(c, 2), Tuple.new(0.4, 0.6, 0.8))
  end

  test "multiplying two colors (hadamard product)" do
    c1 = Color.new(1, 0.2, 0.4)
    c2 = Color.new(0.9, 1, 0.1)
    assert Tuple.equal?(Tuple.multiply(c1, c2), Tuple.new(0.9, 0.2, 0.04))
  end

  test "scaling pixel output and clamping" do
    assert Color.new(255, 0, 0) == Color.scale(Color.new(1.5, 0, 0), 255)
    assert Color.new(0, 128, 0) == Color.scale(Color.new(0, 0.5, 0), 255)
    assert Color.new(0, 0, 255) == Color.scale(Color.new(-0.5, 0, 1), 255)
  end
end
