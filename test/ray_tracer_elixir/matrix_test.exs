defmodule RayTracerElixir.MatrixTest do
  use ExUnit.Case, async: true

  alias RayTracerElixir.{Matrix, Tuple}

  test "constructing a 4x4 matrix" do
    data = [
      [1, 2, 3, 4],
      [5.5, 6.5, 7.5, 8.5],
      [9, 10, 11, 12],
      [13.5, 14.5, 15.5, 16.5]
    ]

    m = Matrix.new(data)

    assert Matrix.get(m, {0, 0}) == 1
    assert Matrix.get(m, {0, 3}) == 4
    assert Matrix.get(m, {1, 0}) == 5.5
    assert Matrix.get(m, {1, 2}) == 7.5
    assert Matrix.get(m, {2, 2}) == 11
    assert Matrix.get(m, {3, 0}) == 13.5
    assert Matrix.get(m, {3, 2}) == 15.5
  end

  test "can represent a 2x2 matrix" do
    data = [[-3, 5], [1, -2]]

    m = Matrix.new(data)

    assert Matrix.get(m, {0, 0}) == -3
    assert Matrix.get(m, {0, 1}) == 5
    assert Matrix.get(m, {1, 0}) == 1
    assert Matrix.get(m, {1, 1}) == -2
  end

  test "can represent a 3x3 matrix" do
    data = [[-3, 5, 0], [1, -2, -7], [0, 1, 1]]

    m = Matrix.new(data)

    assert Matrix.get(m, {0, 0}) == -3
    assert Matrix.get(m, {1, 1}) == -2
    assert Matrix.get(m, {2, 2}) == 1
  end

  test "matrix equality with identical matrices" do
    a =
      Matrix.new([
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 8, 7, 6],
        [5, 4, 3, 2]
      ])

    b =
      Matrix.new([
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 8, 7, 6],
        [5, 4, 3, 2]
      ])

    assert Matrix.equal?(a, b)
  end

  test "matrix equality with different matrices" do
    a =
      Matrix.new([
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 8, 7, 6],
        [5, 4, 3, 2]
      ])

    b =
      Matrix.new([
        [2, 3, 4, 5],
        [6, 7, 8, 9],
        [8, 7, 6, 5],
        [4, 3, 2, 1]
      ])

    refute Matrix.equal?(a, b)
  end

  describe "multiplication" do
    test "multiplying two matrices" do
      a =
        Matrix.new([
          [1, 2, 3, 4],
          [5, 6, 7, 8],
          [9, 8, 7, 6],
          [5, 4, 3, 2]
        ])

      b =
        Matrix.new([
          [-2, 1, 2, 3],
          [3, 2, 1, -1],
          [4, 3, 6, 5],
          [1, 2, 7, 8]
        ])

      result = Matrix.multiply(a, b)

      assert Matrix.to_lists(result) == [
               [20, 22, 50, 48],
               [44, 54, 114, 108],
               [40, 58, 110, 102],
               [16, 26, 46, 42]
             ]
    end

    test "matrix multiplied by a tuple" do
      matrix =
        Matrix.new([
          [1, 2, 3, 4],
          [2, 4, 4, 2],
          [8, 6, 4, 1],
          [0, 0, 0, 1]
        ])

      tuple = Tuple.new(1, 2, 3, 1)
      assert Tuple.equal?(Matrix.multiply(matrix, tuple), Tuple.new(18, 24, 33, 1))
    end

    test "multiplying a matrix by the identity matrix" do
      matrix =
        Matrix.new([
          [0, 1, 2, 4],
          [1, 2, 4, 8],
          [2, 4, 8, 16],
          [4, 8, 16, 32]
        ])

      assert Matrix.equal?(
               Matrix.multiply(matrix, Matrix.identity_matrix()),
               matrix
             )
    end
  end

  test "transposing a matrix" do
    matrix =
      Matrix.new([
        [0, 9, 3, 0],
        [9, 8, 0, 8],
        [1, 8, 5, 3],
        [0, 0, 5, 8]
      ])

    transposed = Matrix.transpose(matrix)

    assert Matrix.equal?(
             transposed,
             Matrix.new([
               [0, 9, 1, 0],
               [9, 8, 8, 0],
               [3, 0, 5, 5],
               [0, 8, 3, 8]
             ])
           )
  end

  test "transposing the identity matrix" do
    assert Matrix.identity_matrix() == Matrix.transpose(Matrix.identity_matrix())
  end
end