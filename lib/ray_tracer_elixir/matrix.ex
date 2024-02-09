defmodule RayTracerElixir.Matrix do
  defstruct [:width, :height, :map]

  alias RayTracerElixir.{Numbers, Tuple}

  def identity_matrix do
    new([
      [1, 0, 0, 0],
      [0, 1, 0, 0],
      [0, 0, 1, 0],
      [0, 0, 0, 1]
    ])
  end

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

  def multiply(a, b) when is_struct(b, __MODULE__) do
    iterate_matrix(a, fn row, col ->
      get(a, {row, 0}) * get(b, {0, col}) +
        get(a, {row, 1}) * get(b, {1, col}) +
        get(a, {row, 2}) * get(b, {2, col}) +
        get(a, {row, 3}) * get(b, {3, col})
    end)
    |> new()
  end

  def multiply(matrix, tuple) do
    components = Tuple.to_components(tuple)

    for row <- 0..(matrix.height - 1) do
      components
      |> Enum.with_index()
      |> Enum.map(fn {component, index} ->
        get(matrix, {row, index}) * component
      end)
      |> Enum.sum()
    end
    |> Tuple.new()
  end

  def transpose(matrix) do
    iterate_matrix(matrix, fn row, col ->
      get(matrix, {col, row})
    end)
    |> new()
  end

  def determinate(matrix) do
    get(matrix, {0, 0}) * get(matrix, {1, 1}) - get(matrix, {0, 1}) * get(matrix, {1, 0})
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
