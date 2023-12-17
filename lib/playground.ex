defmodule RayTracerElixir.Playground do
  def tick(env, proj) do
    position = Components.add(proj.position, proj.velocity)
    velocity = Components.add(proj.velocity, Components.add(env.gravity, env.wind))
    projectile(position, velocity)
  end

  def projectile(position, velocity), do: %{position: position, velocity: velocity}
  def environment(gravity, wind), do: %{gravity: gravity, wind: wind}
end
