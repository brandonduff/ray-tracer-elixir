defmodule RayTracerElixir.Matrix do
  defstruct [:width, :height, :map]

  alias RayTracerElixir.Numbers

  def new(data) do
    map =
      Stream.with_index(data)
      |> Stream.flat_map(fn {row, row_index} ->
        Stream.with_index(row)
        |> Stream.map(fn {cell, col_index} ->
          {{row_index, col_index}, cell}
        end)
      end)
      |> Map.new()

    width = Enum.count(List.first(data))
    height = Enum.count(data)

    %__MODULE__{width: width, height: height, map: map}
  end

  def get(matrix, coordinates) do
    Map.fetch!(matrix.map, coordinates)
  end

  def equal?(a, b) do
    if a.width != b.width || a.height != b.height do
      false
    else
      iterate_matrix(a, fn i, j ->
        {get(a, {i, j}), get(b, {i, j})}
      end)
      |> List.flatten()
      |> Enum.all?(fn {a, b} -> Numbers.close?(a, b) end)
    end
  end

  def multiply(a, b) do
    iterate_matrix(a, fn row, col ->
      get(a, {row, 0}) * get(b, {0, col}) +
        get(a, {row, 1}) * get(b, {1, col}) +
        get(a, {row, 2}) * get(b, {2, col}) +
        get(a, {row, 3}) * get(b, {3, col})
    end)
    |> new()
  end

  def to_lists(matrix) do
    iterate_matrix(matrix, fn row, col -> get(matrix, {row, col}) end)
  end

  defp iterate_matrix(matrix, func) do
    for row <- 0..(matrix.height - 1) do
      for col <- 0..(matrix.width - 1) do
        func.(row, col)
      end
    end
  end
end
