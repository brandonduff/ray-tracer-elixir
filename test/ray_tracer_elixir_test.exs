# TODO:
# - Extract a Tuple module maybe

defmodule RayTracerElixirTest do
  use ExUnit.Case

  test "creating a tuple" do
    result = RayTracerElixir.tuple(5, 6, 7, 8)
    assert result.x == 5
    assert result.y == 6
    assert result.z == 7
    assert result.w == 8
  end

  test "tuple with w=1.0 is a point" do
    a = RayTracerElixir.tuple(4.3, -4.2, 3.1, 1.0)
    assert RayTracerElixir.point?(a)
    refute RayTracerElixir.vector?(a)
  end

  test "tuple with w=0 is a vector" do
    a = RayTracerElixir.tuple(4.3, -4.2, 3.1, 0)
    assert RayTracerElixir.vector?(a)
    refute RayTracerElixir.point?(a)
  end

  test "creating point with factory function" do
    p = RayTracerElixir.point(4, -4, 3)
    assert p == RayTracerElixir.tuple(4, -4, 3, 1)
  end

  test "creating vector with factory function" do
    v = RayTracerElixir.vector(4, -4, 3)
    assert v == RayTracerElixir.tuple(4, -4, 3, 0)
  end

  test "comparing two tuples (float comparison)" do
    assert RayTracerElixir.equal?(
             RayTracerElixir.vector(1, 1, 1.0000000000001),
             RayTracerElixir.vector(1, 1, 1)
           )

    refute RayTracerElixir.equal?(
             RayTracerElixir.vector(1, 1, 1),
             RayTracerElixir.vector(1, 1, 2)
           )
  end

  test "adding two tuples" do
    a = RayTracerElixir.tuple(3, -2, 5, 1)
    b = RayTracerElixir.tuple(-2, 3, 1, 0)
    assert RayTracerElixir.equal?(RayTracerElixir.add(a, b), RayTracerElixir.tuple(1, 1, 6, 1))
  end

  test "subtracting two points" do
    p1 = RayTracerElixir.point(3, 2, 1)
    p2 = RayTracerElixir.point(5, 6, 7)
    result = RayTracerElixir.subtract(p1, p2)
    assert RayTracerElixir.equal?(result, RayTracerElixir.vector(-2, -4, -6))
  end

  test "subtracting a vector from a point" do
    p = RayTracerElixir.point(3, 2, 1)
    v = RayTracerElixir.vector(5, 6, 7)
    result = RayTracerElixir.subtract(p, v)
    assert RayTracerElixir.equal?(result, RayTracerElixir.point(-2, -4, -6))
  end

  test "subtracting two vectors" do
    v1 = RayTracerElixir.vector(3, 2, 1)
    v2 = RayTracerElixir.vector(5, 6, 7)
    result = RayTracerElixir.subtract(v1, v2)
    assert RayTracerElixir.equal?(result, RayTracerElixir.vector(-2, -4, -6))
  end

  test "negating a tuple" do
    a = RayTracerElixir.tuple(1, -2, 3, -4)
    assert RayTracerElixir.equal?(RayTracerElixir.negate(a), RayTracerElixir.tuple(-1, 2, -3, 4))
  end
end
