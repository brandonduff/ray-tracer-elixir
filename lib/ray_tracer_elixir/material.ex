defmodule RayTracerElixir.Material do
  alias RayTracerElixir.Tuple
  alias RayTracerElixir.Vector
  alias RayTracerElixir.Color

  def new(opts \\ []) do
    %{
      color: Keyword.get(opts, :color, Color.new(1, 1, 1)),
      ambient: 0.1,
      diffuse: 0.9,
      specular: 0.9,
      shininess: 200.0
    }
    |> Map.merge(Map.new(opts))
  end

  def lighting(material, light, point, eyev, normalv, in_shadow \\ false) do
    result = %{material: material, light: light, normalv: normalv, eyev: eyev, point: point}

    result = Map.put(result, :effective_color, effective_color(result))
    result = Map.put(result, :lightv, lightv(result))
    result = Map.put(result, :ambient, ambient(result))
    result = Map.put(result, :light_dot_normal, light_dot_normal(result))

    if in_shadow do
      result.ambient
    else
      result = Map.put(result, :diffuse, diffuse(result))
      result = Map.put(result, :specular, specular(result))
      result.ambient |> Tuple.add(result.diffuse) |> Tuple.add(result.specular)
    end
  end

  defp effective_color(%{material: material, light: light}) do
    Tuple.multiply(material.color, light.intensity)
  end

  defp lightv(%{light: light, point: point}) do
    Vector.normalize(Tuple.subtract(light.position, point))
  end

  defp ambient(%{effective_color: effective_color, material: material}) do
    Tuple.multiply(effective_color, material.ambient)
  end

  defp light_dot_normal(%{lightv: lightv, normalv: normalv}) do
    Vector.dot(lightv, normalv)
  end

  defp diffuse(%{light_dot_normal: light_dot_normal})
       when light_dot_normal < 0 do
    Color.new(0, 0, 0)
  end

  defp diffuse(%{
         effective_color: effective_color,
         material: material,
         light_dot_normal: light_dot_normal
       }) do
    effective_color
    |> Tuple.multiply(material.diffuse)
    |> Tuple.multiply(light_dot_normal)
  end

  defp specular(%{light_dot_normal: light_dot_normal})
       when light_dot_normal < 0 do
    Color.new(0, 0, 0)
  end

  defp specular(%{eyev: eyev, normalv: normalv, material: material, lightv: lightv, light: light}) do
    reflectv = Vector.reflect(Tuple.negate(lightv), normalv)
    reflect_dot_eye = Vector.dot(reflectv, eyev)

    if reflect_dot_eye <= 0 do
      Color.new(0, 0, 0)
    else
      factor = :math.pow(reflect_dot_eye, material.shininess)

      light.intensity
      |> Tuple.multiply(material.specular)
      |> Tuple.multiply(factor)
    end
  end
end
