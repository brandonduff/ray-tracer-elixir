defmodule RayTracerElixir.Playground do
  alias RayTracerElixir.Transformation
  alias RayTracerElixir.Camera
  alias RayTracerElixir.World
  alias RayTracerElixir.Light
  alias RayTracerElixir.Material
  alias RayTracerElixir.Intersection
  alias RayTracerElixir.Ray
  alias RayTracerElixir.Sphere
  alias RayTracerElixir.{Tuple, Point, Vector, Canvas, Color, PPM, Matrix}

  def tick(env, proj) do
    position = Tuple.add(proj.position, proj.velocity)
    velocity = Tuple.add(proj.velocity, Tuple.add(env.gravity, env.wind))
    projectile(position, velocity)
  end

  def projectile(position, velocity), do: %{position: position, velocity: velocity}
  def environment(gravity, wind), do: %{gravity: gravity, wind: wind}

  def draw_parabola() do
    start = Point.new(0, 1, 0)
    velocity = Vector.new(1, 1.8, 0) |> Vector.normalize() |> Tuple.multiply(11.25)
    p = projectile(start, velocity)

    gravity = Vector.new(0, -0.1, 0)
    wind = Vector.new(-0.03, 0, 0)
    e = environment(gravity, wind)

    c = Canvas.new(900, 550)
    c = plot_all(c, e, p)
    write_ppm(c, "projectile.ppm")
  end

  def draw_clock() do
    center = Matrix.multiply(Matrix.translation(100, 100, 0), Point.new(0, 0, 0))
    noon = Point.new(0, 1, 0)

    for i <- 1..12 do
      Matrix.multiply([Matrix.rotation_z(i * :math.pi() / 6)], noon)
      |> Tuple.multiply(Point.new(75, 75, 0))
      |> Tuple.add(center)
    end
    |> Enum.reduce(Canvas.new(200, 200), fn point, c ->
      Canvas.write_pixel(c, round(point.x), round(point.y), Color.new(255, 0, 0))
    end)
    |> write_ppm("clock.ppm")
  end

  def plot_all(canvas, env, projectile) do
    c = plot(canvas, projectile.position.x, projectile.position.y)

    # Perhaps canvas should return an error or something if we try to write outside of it
    if projectile.position.x < canvas.width && projectile.position.y > 0 do
      plot_all(c, env, tick(env, projectile))
    else
      c
    end
  end

  def draw_sphere_shadow() do
    ray_origin = Point.new(0, 0, -5)
    wall_z = 10
    wall_size = 7.0
    canvas_pixels = 100
    pixel_size = wall_size / canvas_pixels
    half = wall_size / 2

    canvas = Canvas.new(canvas_pixels, canvas_pixels)
    color = Color.new(1, 0, 0)
    shape = Sphere.new()

    for y <- 0..(canvas_pixels - 1), x <- 0..(canvas_pixels - 1) do
      world_y = half - pixel_size * y
      world_x = -half + pixel_size * x
      position = Point.new(world_x, world_y, wall_z)

      r = Ray.new(ray_origin, Vector.normalize(Tuple.subtract(position, ray_origin)))
      xs = Sphere.intersect(shape, r)

      if Intersection.hit(xs) do
        {x, y}
      end
    end
    |> Enum.reduce(canvas, fn
      {x, y}, c ->
        Canvas.write_pixel(c, x, y, color)

      nil, c ->
        c
    end)
    |> write_ppm("sphere_shadow.ppm")
  end

  def draw_sphere() do
    ray_origin = Point.new(0, 0, -5)
    wall_z = 10
    wall_size = 7.0
    canvas_pixels = 300
    pixel_size = wall_size / canvas_pixels
    half = wall_size / 2

    canvas = Canvas.new(canvas_pixels, canvas_pixels)
    shape = Sphere.new()
    shape = put_in(shape.material, Material.new())
    shape = put_in(shape.material.color, Color.new(1, 0.2, 1))

    light_position = Point.new(5, 5, -10)
    light_color = Color.new(1, 1, 1)
    light = Light.point_light(light_position, light_color)

    for y <- 0..(canvas_pixels - 1), x <- 0..(canvas_pixels - 1) do
      {x, y}
    end
    |> Task.async_stream(
      fn {x, y} ->
        world_y = half - pixel_size * y
        world_x = -half + pixel_size * x
        position = Point.new(world_x, world_y, wall_z)

        r = Ray.new(ray_origin, Vector.normalize(Tuple.subtract(position, ray_origin)))
        xs = Sphere.intersect(shape, r)

        if hit = Intersection.hit(xs) do
          point = Ray.position(r, hit.t)
          normal = Sphere.normal_at(hit.object, point)
          eye = Tuple.negate(r.direction)
          color = Material.lighting(hit.object.material, light, point, eye, normal)
          {x, y, color}
        end
      end,
      ordered: false
    )
    |> Enum.reduce(canvas, fn
      {:ok, {x, y, color}}, c ->
        Canvas.write_pixel(c, x, y, color)

      {:ok, nil}, c ->
        c
    end)
    |> write_ppm("sphere.ppm")
  end

  def draw_simple_scene do
    floor =
      Sphere.new()
      |> Map.put(:transform, Matrix.scaling(10, 0.01, 10))
      |> Map.put(:material, Material.new())
      |> put_in([:material, :color], Color.new(1, 0.9, 0.9))
      |> put_in([:material, :specular], 0)

    left_wall =
      Sphere.new()
      |> Map.put(
        :transform,
        Matrix.multiply(
          Matrix.translation(0, 0, 5),
          Matrix.multiply(
            Matrix.rotation_y(-:math.pi() / 4),
            Matrix.multiply(Matrix.rotation_x(:math.pi() / 2), Matrix.scaling(10, 0.01, 10))
          )
        )
      )
      |> Map.put(:material, floor.material)

    right_wall =
      Sphere.new()
      |> Map.put(
        :transform,
        Matrix.multiply(
          Matrix.translation(0, 0, 5),
          Matrix.multiply(
            Matrix.rotation_y(:math.pi() / 4),
            Matrix.multiply(Matrix.rotation_x(:math.pi() / 2), Matrix.scaling(10, 0.01, 10))
          )
        )
      )
      |> Map.put(:material, floor.material)

    middle =
      Sphere.new()
      |> Map.put(:transform, Matrix.translation(-0.5, 1, 0.5))
      |> Map.put(:material, Material.new())
      |> put_in([:material, :color], Color.new(0.1, 1, 0.5))
      |> put_in([:material, :diffuse], 0.7)
      |> put_in([:material, :specular], 0.3)

    right =
      Sphere.new()
      |> put_in(
        [:transform],
        Matrix.multiply(Matrix.translation(1.5, 0.5, -0.5), Matrix.scaling(0.5, 0.5, 0.5))
      )
      |> put_in([:material], Material.new())
      |> put_in([:material, :color], Color.new(0.5, 1, 0.1))
      |> put_in([:material, :diffuse], 0.7)
      |> put_in([:material, :specular], 0.3)

    left =
      Sphere.new()
      |> put_in(
        [:transform],
        Matrix.multiply(Matrix.translation(-1.5, 0.33, -0.75), Matrix.scaling(0.33, 0.33, 0.33))
      )
      |> put_in([:material], Material.new())
      |> put_in([:material, :color], Color.new(1, 0.8, 0.1))
      |> put_in([:material, :diffuse], 0.7)
      |> put_in([:material, :specular], 0.3)

    world =
      World.new()
      |> Map.put(:light_source, Light.point_light(Point.new(-10, 10, -10), Color.new(1, 1, 1)))

    world = Map.put(world, :objects, [floor, left_wall, right_wall, middle, right, left])

    camera =
      Camera.new(1600, 800, :math.pi() / 3)
      |> Map.put(
        :transform,
        Transformation.view_transform(
          Point.new(0, 1.5, -5),
          Point.new(0, 1, 0),
          Point.new(0, 1, 0)
        )
      )

    canvas = Camera.render(camera, world)

    write_ppm(canvas, "simple_scene.ppm")
  end

  defp plot(canvas, x, y) do
    Canvas.write_pixel(canvas, round(x), canvas.height - round(y), Color.new(255, 0, 0))
  end

  defp write_ppm(canvas, filename) do
    ppm = PPM.write(canvas)
    File.write!(filename, ppm)
  end
end
