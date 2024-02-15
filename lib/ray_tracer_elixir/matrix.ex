defmodule RayTracerElixir.Matrix do
  require Integer

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

  def translation(transformations, x, y, z) do
    [translation(x, y, z) | transformations]
  end

  def translation(x, y, z) do
    new([
      [1, 0, 0, x],
      [0, 1, 0, y],
      [0, 0, 1, z],
      [0, 0, 0, 1]
    ])
  end

  def scaling(transformations, x, y, z) do
    [scaling(x, y, z) | transformations]
  end

  def scaling(x, y, z) do
    new([
      [x, 0, 0, 0],
      [0, y, 0, 0],
      [0, 0, z, 0],
      [0, 0, 0, 1]
    ])
  end

  def rotation_x(r) do
    new([
      [1, 0, 0, 0],
      [0, :math.cos(r), -:math.sin(r), 0],
      [0, :math.sin(r), :math.cos(r), 0],
      [0, 0, 0, 1]
    ])
  end

  def rotation_x(transformations, r) do
    [rotation_x(r) | transformations]
  end

  def rotation_y(r) do
    new([
      [:math.cos(r), 0, :math.sin(r), 0],
      [0, 1, 0, 0],
      [-:math.sin(r), 0, :math.cos(r), 0],
      [0, 0, 0, 1]
    ])
  end

  def rotation_z(r) do
    new([
      [:math.cos(r), -:math.sin(r), 0, 0],
      [:math.sin(r), :math.cos(r), 0, 0],
      [0, 0, 1, 0],
      [0, 0, 0, 1]
    ])
  end

  def shearing(x_y, x_z, y_x, y_z, z_x, z_y) do
    new([
      [1, x_y, x_z, 0],
      [y_x, 1, y_z, 0],
      [z_x, z_y, 1, 0],
      [0, 0, 0, 1]
    ])
  end

  def build_transformation() do
    []
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

  def get(matrix, row, col) do
    Map.fetch!(matrix.map, {row, col})
  end

  def equal?(a, b) do
    if a.width != b.width || a.height != b.height do
      false
    else
      iterate_matrix(a, fn i, j ->
        {get(a, i, j), get(b, i, j)}
      end)
      |> List.flatten()
      |> Enum.all?(fn {a, b} -> Numbers.close?(a, b) end)
    end
  end

  def multiply(transformations, value) when is_list(transformations) do
    transformations
    |> Enum.reverse()
    |> List.insert_at(0, value)
    |> Enum.reduce(fn transform, acc ->
      multiply(transform, acc)
    end)
  end

  def multiply(a, b) when is_struct(b, __MODULE__) do
    iterate_matrix(a, fn row, col ->
      get(a, row, 0) * get(b, 0, col) +
        get(a, row, 1) * get(b, 1, col) +
        get(a, row, 2) * get(b, 2, col) +
        get(a, row, 3) * get(b, 3, col)
    end)
    |> new()
  end

  def multiply(matrix, tuple) do
    components = Tuple.to_components(tuple)

    for row <- 0..(matrix.height - 1) do
      components
      |> Enum.with_index()
      |> Enum.map(fn {component, index} ->
        get(matrix, row, index) * component
      end)
      |> Enum.sum()
    end
    |> Tuple.new()
  end

  def transpose(matrix) do
    iterate_matrix(matrix, fn row, col ->
      get(matrix, col, row)
    end)
    |> new()
  end

  def determinate(%{height: 2} = matrix) do
    get(matrix, 0, 0) * get(matrix, 1, 1) - get(matrix, 0, 1) * get(matrix, 1, 0)
  end

  def determinate(matrix) do
    for col <- 0..(matrix.width - 1) do
      get(matrix, 0, col) * cofactor(matrix, 0, col)
    end
    |> Enum.sum()
  end

  def submatrix(matrix, row_to_delete, col_to_delete) do
    matrix
    |> to_lists()
    |> Enum.map(&reject_at_index(&1, col_to_delete))
    |> reject_at_index(row_to_delete)
    |> new()
  end

  def minor(matrix, row, col) do
    matrix
    |> submatrix(row, col)
    |> determinate()
  end

  def cofactor(matrix, row, col) do
    minor = minor(matrix, row, col)
    if Integer.is_even(row + col), do: minor, else: -minor
  end

  def invertible?(matrix) do
    determinate(matrix) != 0
  end

  def inverse(matrix) do
    if !invertible?(matrix) do
      throw("matrix not invertible")
    end

    iterate_matrix(matrix, fn col, row ->
      cofactor(matrix, row, col) / determinate(matrix)
    end)
    |> new()
  end

  def to_lists(matrix) do
    iterate_matrix(matrix, fn row, col -> get(matrix, row, col) end)
  end

  defp reject_at_index(enum, index) do
    enum
    |> Enum.with_index()
    |> Enum.reject(fn {_val, col_index} -> col_index == index end)
    |> Enum.map(&elem(&1, 0))
  end

  defp iterate_matrix(matrix, func) do
    for row <- 0..(matrix.height - 1) do
      for col <- 0..(matrix.width - 1) do
        func.(row, col)
      end
    end
  end
end
