defmodule RayTracerElixir.Camera do
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

    Map.put(camera, :pixel_size, (camera.half_width * 2) / camera.hsize)
  end
end
