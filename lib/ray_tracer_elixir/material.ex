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
    effective_color = Tuple.multiply(material.color, light.intensity)
    lightv = Vector.normalize(Tuple.subtract(light.position, point))
    ambient = Tuple.multiply(effective_color, material.ambient)

    light_dot_normal = Vector.dot(lightv, normalv)

    {diffuse, specular} =
      if light_dot_normal < 0 do
        {Color.new(0, 0, 0), Color.new(0, 0, 0)}
      else
        diffuse =
          effective_color |> Tuple.multiply(material.diffuse) |> Tuple.multiply(light_dot_normal)

        reflectv = Vector.reflect(Tuple.negate(lightv), normalv)
        reflect_dot_eye = Vector.dot(reflectv, eyev)

        specular =
          if reflect_dot_eye <= 0 do
            Color.new(0, 0, 0)
          else
            factor = :math.pow(reflect_dot_eye, material.shininess)

            light.intensity |> Tuple.multiply(material.specular) |> Tuple.multiply(factor)
          end

        {diffuse, specular}
      end

    ambient |> Tuple.add(diffuse) |> Tuple.add(specular)
  end
end
