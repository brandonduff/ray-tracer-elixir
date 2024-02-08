defmodule RayTracerElixir.Matrix do
  def new(data) do
    Stream.with_index(data)
    |> Stream.flat_map(fn {row, row_index} ->
      Stream.with_index(row)
      |> Stream.map(fn {cell, col_index} ->
        {{row_index, col_index}, cell}
      end)
    end)
    |> Map.new()
  end

  def get(matrix, coordinates) do
    Map.fetch!(matrix, coordinates)
  end
end
