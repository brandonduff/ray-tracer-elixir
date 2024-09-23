defmodule RayTracerElixir.Material do
  alias RayTracerElixir.Tuple
  alias RayTracerElixir.Vector
  alias RayTracerElixir.Color

  def new do
    %{
      color: Color.new(1, 1, 1),
      ambient: 0.1,
      diffuse: 0.9,
      specular: 0.9,
      shininess: 200.0
    }
  end

  def lighting(material, light, point, eyev, normalv) do
    result = %{material: material, light: light, normalv: normalv, eyev: eyev}

    result =
      Map.put(result, :effective_color, Tuple.multiply(material.color, light.intensity))
      |> Map.put(:lightv, Vector.normalize(Tuple.subtract(light.position, point)))

    result = Map.put(result, :ambient, Tuple.multiply(result.effective_color, material.ambient))
    result = Map.put(result, :light_dot_normal, Vector.dot(result.lightv, normalv))

    result = result |> calculate_diffuse() |> calculate_specular()

    result.ambient |> Tuple.add(result.diffuse) |> Tuple.add(result.specular)
  end

  defp calculate_diffuse(%{light_dot_normal: light_dot_normal} = result)
       when light_dot_normal < 0 do
    Map.put(result, :diffuse, Color.new(0, 0, 0))
  end

  defp calculate_diffuse(result) do
    diffuse =
      result.effective_color
      |> Tuple.multiply(result.material.diffuse)
      |> Tuple.multiply(result.light_dot_normal)

    Map.put(result, :diffuse, diffuse)
  end

  defp calculate_specular(%{light_dot_normal: light_dot_normal} = result)
       when light_dot_normal < 0 do
    Map.put(result, :specular, Color.new(0, 0, 0))
  end

  defp calculate_specular(result) do
    reflectv = Vector.reflect(Tuple.negate(result.lightv), result.normalv)
    reflect_dot_eye = Vector.dot(reflectv, result.eyev)

    specular =
      if reflect_dot_eye <= 0 do
        Color.new(0, 0, 0)
      else
        factor = :math.pow(reflect_dot_eye, result.material.shininess)

        result.light.intensity
        |> Tuple.multiply(result.material.specular)
        |> Tuple.multiply(factor)
      end

    Map.put(result, :specular, specular)
  end
end
