defmodule RayTracerElixir.TupleTest do
  use ExUnit.Case, async: true
  alias RayTracerElixir.Tuple

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
    p = Tuple.new_point(4, -4, 3)
    assert p == Tuple.new(4, -4, 3, 1)
  end

  test "creating vector with factory function" do
    v = Tuple.new_vector(4, -4, 3)
    assert v == Tuple.new(4, -4, 3, 0)
  end

  test "comparing two tuples (float comparison)" do
    assert Components.equal?(
             Tuple.new_vector(1, 1, 1.0000000000001),
             Tuple.new_vector(1, 1, 1)
           )

    refute Components.equal?(
             Tuple.new_vector(1, 1, 1),
             Tuple.new_vector(1, 1, 2)
           )
  end

  test "adding two tuples" do
    a = Components.new(3, -2, 5, 1)
    b = Components.new(-2, 3, 1, 0)
    assert Components.equal?(Components.add(a, b), Components.new(1, 1, 6, 1))
  end

  test "subtracting two points" do
    p1 = Tuple.new_point(3, 2, 1)
    p2 = Tuple.new_point(5, 6, 7)
    result = Components.subtract(p1, p2)
    assert Components.equal?(result, Tuple.new_vector(-2, -4, -6))
  end

  test "subtracting a vector from a point" do
    p = Tuple.new_point(3, 2, 1)
    v = Tuple.new_vector(5, 6, 7)
    result = Components.subtract(p, v)
    assert Components.equal?(result, Tuple.new_point(-2, -4, -6))
  end

  test "subtracting two vectors" do
    v1 = Tuple.new_vector(3, 2, 1)
    v2 = Tuple.new_vector(5, 6, 7)
    result = Components.subtract(v1, v2)
    assert Components.equal?(result, Tuple.new_vector(-2, -4, -6))
  end

  test "negating a tuple" do
    a = Tuple.new(1, -2, 3, -4)
    assert Components.equal?(Components.negate(a), Components.new(-1, 2, -3, 4))
  end

  test "multiplying a tuple by a scalar" do
    a = Tuple.new(1, -2, 3, -4)
    assert Components.equal?(Components.multiply(a, 3.5), Components.new(3.5, -7, 10.5, -14))
  end

  test "multiplying a tuple by a fraction" do
    a = Tuple.new(1, -2, 3, -4)
    assert Components.equal?(Components.multiply(a, 0.5), Components.new(0.5, -1, 1.5, -2))
  end

  test "dividing a tuple by a scalar" do
    a = Tuple.new(1, -2, 3, -4)
    assert Components.equal?(Components.divide(a, 2), Components.new(0.5, -1, 1.5, -2))
  end

  test "magnitude of vectors" do
    v = Tuple.new_vector(1, 0, 0)
    assert Tuple.magnitude(v) == 1

    v = Tuple.new_vector(0, 1, 0)
    assert Tuple.magnitude(v) == 1

    v = Tuple.new_vector(0, 0, 1)
    assert Tuple.magnitude(v) == 1

    v = Tuple.new_vector(1, 2, 3)
    assert Tuple.magnitude(v) == :math.sqrt(14)

    v = Tuple.new_vector(-1, -2, -3)
    assert Tuple.magnitude(v) == :math.sqrt(14)
  end

  test "normalizing vectors" do
    v = Tuple.new_vector(4, 0, 0)
    assert Components.equal?(Tuple.normalize(v), Tuple.new_vector(1, 0, 0))

    v = Tuple.new_vector(1, 2, 3)
    assert Components.equal?(Tuple.normalize(v), Tuple.new_vector(0.26726, 0.53452, 0.80178))

    assert Tuple.magnitude(Tuple.normalize(v)) == 1
  end

  test "dot product of two tuples" do
    a = Tuple.new_vector(1, 2, 3)
    b = Tuple.new_vector(2, 3, 4)
    assert Tuple.dot(a, b) == 20
  end

  test "cross product" do
    a = Tuple.new_vector(1, 2, 3)
    b = Tuple.new_vector(2, 3, 4)
    assert Components.equal?(Tuple.cross(a, b), Tuple.new_vector(-1, 2, -1))
    assert Components.equal?(Tuple.cross(b, a), Tuple.new_vector(1, -2, 1))
  end
end
