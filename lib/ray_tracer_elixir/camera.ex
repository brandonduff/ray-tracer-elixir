defmodule RayTracerElixir.Camera do
  alias RayTracerElixir.World
  alias RayTracerElixir.Canvas
  alias RayTracerElixir.Tuple
  alias RayTracerElixir.Vector
  alias RayTracerElixir.Point
  alias RayTracerElixir.Ray
  alias RayTracerElixir.Matrix

  def new(hsize, vsize, field_of_view) do
    camera = %{
      hsize: hsize,
      vsize: vsize,
      field_of_view: field_of_view,
      transform: Matrix.identity_matrix()
    }

    add_pixel_size(camera)
  end

  def ray_for_pixel(camera, px, py) do
    xoffset = (px + 0.5) * camera.pixel_size
    yoffset = (py + 0.5) * camera.pixel_size

    world_x = camera.half_width - xoffset
    world_y = camera.half_height - yoffset

    pixel = Matrix.inverse(camera.transform) |> Matrix.multiply(Point.new(world_x, world_y, -1))
    origin = Matrix.inverse(camera.transform) |> Matrix.multiply(Point.new(0, 0, 0))
    direction = Vector.normalize(Tuple.subtract(pixel, origin))

    Ray.new(origin, direction)
  end

  def render(camera, world) do
    for y <- 0..(camera.vsize - 1), x <- 0..(camera.hsize - 1) do
      {x, y}
    end
    |> Task.async_stream(
      fn {x, y} ->
        ray = ray_for_pixel(camera, x, y)
        color = World.color_at(world, ray)
        {x, y, color}
      end,
      ordered: false
    )
    |> Enum.reduce(Canvas.new(camera.hsize, camera.vsize), fn {:ok, {x, y, color}}, image ->
      Canvas.write_pixel(image, x, y, color)
    end)
  end

  defp add_pixel_size(camera) do
    half_view = :math.tan(camera.field_of_view / 2)
    aspect = camera.hsize / camera.vsize

    camera =
      if aspect >= 1 do
        camera
        |> Map.put(:half_width, half_view)
        |> Map.put(:half_height, half_view / aspect)
      else
        camera
        |> Map.put(:half_width, half_view * aspect)
        |> Map.put(:half_height, half_view)
      end

    Map.put(camera, :pixel_size, camera.half_width * 2 / camera.hsize)
  end
end
