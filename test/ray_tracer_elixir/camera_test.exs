defmodule RayTracerElixir.CameraTest do
  alias RayTracerElixir.Numbers
  alias RayTracerElixir.Camera
  alias RayTracerElixir.Matrix
  use ExUnit.Case, async: true

  test "Constructing a camera" do
    hsize = 160
    vsize = 120
    field_of_view = :math.pi/2

    c = Camera.new(hsize, vsize, field_of_view)

    assert c.hsize == 160
    assert c.vsize == 120
    assert c.transform == Matrix.identity_matrix()
  end

  test "The pixel size for a horizontal canvas" do
    c = Camera.new(200, 125, :math.pi / 2)
    assert Numbers.close?(c.pixel_size, 0.01)
  end

  test "The pixel size for a vertical canvas" do
    c = Camera.new(125, 200, :math.pi/2)
    assert Numbers.close?(c.pixel_size, 0.01)
  end
end
