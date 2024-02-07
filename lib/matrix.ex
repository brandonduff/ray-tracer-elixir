defmodule RayTracerElixir.Matrix do
  def new(data) do
    Enum.with_index(data)
    |> Enum.map(fn {row, row_index} ->
      Enum.with_index(row)
      |> Enum.map(fn {cell, col_index} ->
        {{row_index, col_index}, cell}
      end)
    end)
    |> List.flatten()
    |> Map.new()
  end

  def get(matrix, coordinates) do
    Map.fetch!(matrix, coordinates)
  end
end
