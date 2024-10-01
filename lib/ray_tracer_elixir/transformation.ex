defmodule RayTracerElixir.Transformation do
  alias RayTracerElixir.Tuple
  alias RayTracerElixir.Vector
  alias RayTracerElixir.Matrix

  def view_transform(from, to, up) do
    forward = Vector.normalize(Tuple.subtract(to, from))
    upn = Vector.normalize(up)
    left = Vector.cross(forward, upn)
    true_up = Vector.cross(left, forward)

    orientation =
      Matrix.new([
        [left.x, left.y, left.z, 0],
        [true_up.x, true_up.y, true_up.z, 0],
        [-forward.x, -forward.y, -forward.z, 0],
        [0, 0, 0, 1]
      ])

    Matrix.multiply(orientation, Matrix.translation(-from.x, -from.y, -from.z))
  end
end
