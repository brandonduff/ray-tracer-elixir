defmodule RayTracerElixir.Sphere do
  alias RayTracerElixir.Ray
  alias RayTracerElixir.Matrix
  alias RayTracerElixir.Intersection
  alias RayTracerElixir.Vector
  alias RayTracerElixir.Point
  alias RayTracerElixir.Tuple

  def new() do
    %{transform: Matrix.identity_matrix()}
  end

  def intersect(sphere, ray) do
    ray = Ray.transform(ray, Matrix.inverse(sphere.transform))
    sphere_to_ray = Tuple.subtract(ray.origin, Point.new(0, 0, 0))

    a = Vector.dot(ray.direction, ray.direction)
    b = 2 * Vector.dot(ray.direction, sphere_to_ray)
    c = Vector.dot(sphere_to_ray, sphere_to_ray) - 1

    discriminant = b * b - 4 * a * c

    if discriminant >= 0 do
      t1 = (-b - :math.sqrt(discriminant)) / (2 * a)
      t2 = (-b + :math.sqrt(discriminant)) / (2 * a)

      [Intersection.new(t1, sphere), Intersection.new(t2, sphere)]
    else
      []
    end
  end

  def set_transform(sphere, transform) do
    Map.put(sphere, :transform, transform)
  end
end
