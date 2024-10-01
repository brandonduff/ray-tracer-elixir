defmodule RayTracerElixir.TransformationTest do
  use ExUnit.Case, async: true

  alias RayTracerElixir.Matrix
  alias RayTracerElixir.Vector
  alias RayTracerElixir.Point
  alias RayTracerElixir.Transformation

  test "The transformation matrix for the default orientation" do
    from = Point.new(0, 0, 0)
    to = Point.new(0, 0, -1)
    up = Vector.new(0, 1, 0)

    t = Transformation.view_transform(from, to, up)

    assert t == Matrix.identity_matrix()
  end

  test "A view tranformation matrix looking in positive z direction" do
    from = Point.new(0, 0, 0)
    to = Point.new(0, 0, 1)
    up = Vector.new(0, 1, 0)

    t = Transformation.view_transform(from, to, up)

    assert t == Matrix.scaling(-1, 1, -1)
  end

  test "The view transformation moves the world" do
    from = Point.new(0, 0, 8)
    to = Point.new(0, 0, 0)
    up = Vector.new(0, 1, 0)

    t = Transformation.view_transform(from, to, up)

    assert t == Matrix.translation(0, 0, -8)
  end

  test "An arbitrary view transformation" do
    from = Point.new(1, 3, 2)
    to = Point.new(4, -2, 8)
    up = Vector.new(1, 1, 0)

    t = Transformation.view_transform(from, to, up)

    assert Matrix.equal?(
             t,
             Matrix.new([
               [-0.50709, 0.50709, 0.67612, -2.36643],
               [0.76772, 0.60609, 0.12122, -2.82843],
               [-0.35857, 0.59761, -0.71714, 0.00000],
               [0.00000, 0.00000, 0.00000, 1.00000]
             ])
           )
  end
end
