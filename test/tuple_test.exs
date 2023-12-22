defmodule RayTracerElixir.TupleTest do
  use ExUnit.Case, async: true
  alias RayTracerElixir.Tuple
  alias RayTracerElixir.Point
  alias RayTracerElixir.Vector

  test "creating a tuple" do
    result = Tuple.new(5, 6, 7, 8)
    assert result.x == 5
    assert result.y == 6
    assert result.z == 7
    assert result.w == 8
  end

  test "tuple with w=1.0 is a point" do
    a = Tuple.new(4.3, -4.2, 3.1, 1.0)
    assert Tuple.point?(a)
    refute Tuple.vector?(a)
  end

  test "tuple with w=0 is a vector" do
    a = Tuple.new(4.3, -4.2, 3.1, 0)
    assert Tuple.vector?(a)
    refute Tuple.point?(a)
  end

  test "creating point with factory function" do
    p = Point.new(4, -4, 3)
    assert p == Tuple.new(4, -4, 3, 1)
  end

  test "creating vector with factory function" do
    v = Vector.new(4, -4, 3)
    assert v == Tuple.new(4, -4, 3, 0)
  end

  test "comparing two tuples (float comparison)" do
    assert Tuple.equal?(
             Vector.new(1, 1, 1.0000000000001),
             Vector.new(1, 1, 1)
           )

    refute Tuple.equal?(
             Vector.new(1, 1, 1),
             Vector.new(1, 1, 2)
           )
  end

  test "adding two tuples" do
    a = Tuple.new(3, -2, 5, 1)
    b = Tuple.new(-2, 3, 1, 0)
    assert Tuple.equal?(Tuple.add(a, b), Tuple.new(1, 1, 6, 1))
  end

  test "subtracting two points" do
    p1 = Point.new(3, 2, 1)
    p2 = Point.new(5, 6, 7)
    result = Tuple.subtract(p1, p2)
    assert Tuple.equal?(result, Vector.new(-2, -4, -6))
  end

  test "subtracting a vector from a point" do
    p = Point.new(3, 2, 1)
    v = Vector.new(5, 6, 7)
    result = Tuple.subtract(p, v)
    assert Tuple.equal?(result, Point.new(-2, -4, -6))
  end

  test "subtracting two vectors" do
    v1 = Vector.new(3, 2, 1)
    v2 = Vector.new(5, 6, 7)
    result = Tuple.subtract(v1, v2)
    assert Tuple.equal?(result, Vector.new(-2, -4, -6))
  end

  test "negating a tuple" do
    a = Tuple.new(1, -2, 3, -4)
    assert Tuple.equal?(Tuple.negate(a), Tuple.new(-1, 2, -3, 4))
  end

  test "multiplying a tuple by a scalar" do
    a = Tuple.new(1, -2, 3, -4)
    assert Tuple.equal?(Tuple.multiply(a, 3.5), Tuple.new(3.5, -7, 10.5, -14))
  end

  test "multiplying a tuple by a fraction" do
    a = Tuple.new(1, -2, 3, -4)
    assert Tuple.equal?(Tuple.multiply(a, 0.5), Tuple.new(0.5, -1, 1.5, -2))
  end

  test "dividing a tuple by a scalar" do
    a = Tuple.new(1, -2, 3, -4)
    assert Tuple.equal?(Tuple.divide(a, 2), Tuple.new(0.5, -1, 1.5, -2))
  end

  test "magnitude of vectors" do
    v = Vector.new(1, 0, 0)
    assert Vector.magnitude(v) == 1

    v = Vector.new(0, 1, 0)
    assert Vector.magnitude(v) == 1

    v = Vector.new(0, 0, 1)
    assert Vector.magnitude(v) == 1

    v = Vector.new(1, 2, 3)
    assert Vector.magnitude(v) == :math.sqrt(14)

    v = Vector.new(-1, -2, -3)
    assert Vector.magnitude(v) == :math.sqrt(14)
  end

  test "normalizing vectors" do
    v = Vector.new(4, 0, 0)
    assert Tuple.equal?(Vector.normalize(v), Vector.new(1, 0, 0))

    v = Vector.new(1, 2, 3)
    assert Tuple.equal?(Vector.normalize(v), Vector.new(0.26726, 0.53452, 0.80178))

    assert Vector.magnitude(Vector.normalize(v)) == 1
  end

  test "dot product of two tuples" do
    a = Vector.new(1, 2, 3)
    b = Vector.new(2, 3, 4)
    assert Vector.dot(a, b) == 20
  end

  test "cross product" do
    a = Vector.new(1, 2, 3)
    b = Vector.new(2, 3, 4)
    assert Tuple.equal?(Vector.cross(a, b), Vector.new(-1, 2, -1))
    assert Tuple.equal?(Vector.cross(b, a), Vector.new(1, -2, 1))
  end
end
