defmodule RayTracerElixir.Playground do
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
    write_ppm(c, "prjectile.ppm")
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

  defp plot(canvas, x, y) do
    Canvas.write_pixel(canvas, round(x), canvas.height - round(y), Color.new(255, 0, 0))
  end

  defp write_ppm(canvas, filename) do
    ppm = PPM.write(canvas)
    File.write!(filename, ppm)
  end
end
