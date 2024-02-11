defmodule RayTracerElixir.MatrixTest do
  use ExUnit.Case, async: true

  alias RayTracerElixir.{Matrix, Tuple, Point, Vector}

  test "constructing a 4x4 matrix" do
    data = [
      [1, 2, 3, 4],
      [5.5, 6.5, 7.5, 8.5],
      [9, 10, 11, 12],
      [13.5, 14.5, 15.5, 16.5]
    ]

    m = Matrix.new(data)

    assert Matrix.get(m, 0, 0) == 1
    assert Matrix.get(m, 0, 3) == 4
    assert Matrix.get(m, 1, 0) == 5.5
    assert Matrix.get(m, 1, 2) == 7.5
    assert Matrix.get(m, 2, 2) == 11
    assert Matrix.get(m, 3, 0) == 13.5
    assert Matrix.get(m, 3, 2) == 15.5
  end

  test "can represent a 2x2 matrix" do
    data = [[-3, 5], [1, -2]]

    m = Matrix.new(data)

    assert Matrix.get(m, 0, 0) == -3
    assert Matrix.get(m, 0, 1) == 5
    assert Matrix.get(m, 1, 0) == 1
    assert Matrix.get(m, 1, 1) == -2
  end

  test "can represent a 3x3 matrix" do
    data = [[-3, 5, 0], [1, -2, -7], [0, 1, 1]]

    m = Matrix.new(data)

    assert Matrix.get(m, 0, 0) == -3
    assert Matrix.get(m, 1, 1) == -2
    assert Matrix.get(m, 2, 2) == 1
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

  test "calculating the determinate of a 2x2 matrix" do
    matrix = Matrix.new([[1, 5], [-3, 2]])
    assert 17 == Matrix.determinate(matrix)
  end

  describe "submatrix" do
    test "taking a submatrix of a 3x3 matrix creates a 2x2 matrix" do
      matrix =
        Matrix.new([
          [1, 5, 0],
          [-3, 2, 7],
          [0, 6, -3]
        ])

      assert Matrix.equal?(Matrix.submatrix(matrix, 0, 2), Matrix.new([[-3, 2], [0, 6]]))
    end

    test "a submatrix of a 4x4 matrix is a 3x3 matrix" do
      matrix =
        Matrix.new([
          [-6, 1, 1, 6],
          [-8, 5, 8, 6],
          [-1, 0, 8, 2],
          [-7, 1, -1, 1]
        ])

      assert Matrix.equal?(
               Matrix.submatrix(matrix, 2, 1),
               Matrix.new([
                 [-6, 1, 6],
                 [-8, 8, 6],
                 [-7, -1, 1]
               ])
             )
    end
  end

  test "calculating minor of a 3x3 matrix" do
    matrix =
      Matrix.new([
        [3, 5, 0],
        [2, -1, -7],
        [6, -1, 5]
      ])

    submatrix = Matrix.submatrix(matrix, 1, 0)
    assert Matrix.determinate(submatrix) == 25
    assert Matrix.minor(matrix, 1, 0) == 25
  end

  test "calculating cofactor of a 3x3 matrix" do
    matrix =
      Matrix.new([
        [3, 5, 0],
        [2, -1, -7],
        [6, -1, 5]
      ])

    assert Matrix.minor(matrix, 0, 0) == -12
    assert Matrix.cofactor(matrix, 0, 0) == -12
    assert Matrix.minor(matrix, 1, 0) == 25
    assert Matrix.cofactor(matrix, 1, 0) == -25
  end

  test "calculating the determinant of a 3x3 matrix" do
    matrix =
      Matrix.new([
        [1, 2, 6],
        [-5, 8, -4],
        [2, 6, 4]
      ])

    assert Matrix.cofactor(matrix, 0, 0) == 56
    assert Matrix.cofactor(matrix, 0, 1) == 12
    assert Matrix.cofactor(matrix, 0, 2) == -46
    assert Matrix.determinate(matrix) == -196
  end

  describe "inversion" do
    test "an invertible matrix is invertible" do
      matrix =
        Matrix.new([
          [6, 4, 4, 4],
          [5, 5, 7, 6],
          [4, -9, 3, -7],
          [9, 1, 7, -6]
        ])

      assert Matrix.determinate(matrix) == -2120
      assert Matrix.invertible?(matrix)
    end

    test "a noninvertible matrix is not invertible" do
      matrix =
        Matrix.new([
          [-4, 2, -2, -3],
          [9, 6, 2, 6],
          [0, -5, 1, -5],
          [0, 0, 0, 0]
        ])

      assert Matrix.determinate(matrix) == 0
      refute Matrix.invertible?(matrix)
    end

    test "calculating the inverse of a matrix" do
      matrix =
        Matrix.new([
          [-5, 2, 6, -8],
          [1, -5, 1, 8],
          [7, 7, -6, -7],
          [1, -3, 7, 4]
        ])

      inverse = Matrix.inverse(matrix)

      assert Matrix.determinate(matrix) == 532
      assert Matrix.cofactor(matrix, 2, 3) == -160
      assert Matrix.get(inverse, 3, 2) == -160 / 532
      assert Matrix.cofactor(matrix, 3, 2) == 105
      assert Matrix.get(inverse, 2, 3) == 105 / 532

      assert Matrix.equal?(
               inverse,
               Matrix.new([
                 [0.21805, 0.45113, 0.24060, -0.04511],
                 [-0.80827, -1.45677, -0.44361, 0.52068],
                 [-0.07895, -0.22368, -0.05263, 0.19737],
                 [-0.52256, -0.81391, -0.30075, 0.30639]
               ])
             )
    end

    test "calculating the inverse of another matrix" do
      matrix =
        Matrix.new([
          [8, -5, 9, 2],
          [7, 5, 6, 1],
          [-6, 0, 9, 6],
          [-3, 0, -9, -4]
        ])

      assert Matrix.equal?(
               Matrix.inverse(matrix),
               Matrix.new([
                 [-0.15385, -0.15385, -0.28205, -0.53846],
                 [-0.07692, 0.12308, 0.02564, 0.03077],
                 [0.35897, 0.35897, 0.43590, 0.92308],
                 [-0.69231, -0.69231, -0.76923, -1.92308]
               ])
             )
    end

    test "calculating the inverse of a third matrix" do
      matrix =
        Matrix.new([
          [9, 3, 0, 9],
          [-5, -2, -6, -3],
          [-4, 9, 6, 4],
          [-7, 6, 6, 2]
        ])

      assert Matrix.equal?(
               Matrix.inverse(matrix),
               Matrix.new([
                 [-0.04074, -0.07778, 0.14444, -0.22222],
                 [-0.07778, 0.03333, 0.36667, -0.33333],
                 [-0.02901, -0.14630, -0.10926, 0.12963],
                 [0.17778, 0.06667, -0.26667, 0.33333]
               ])
             )
    end

    test "multiplying a product by its inverse" do
      a =
        Matrix.new([
          [3, -9, 7, 3],
          [3, -8, 2, -9],
          [-4, 4, 4, 1],
          [-6, 5, -1, 1]
        ])

      b =
        Matrix.new([
          [8, 2, 2, 2],
          [3, -1, 7, 0],
          [7, 0, 5, 4],
          [6, -2, 0, 5]
        ])

      c = Matrix.multiply(a, b)
      assert Matrix.equal?(Matrix.multiply(c, Matrix.inverse(b)), a)
    end
  end

  describe "translation" do
    test "multiplying by a translation matrix" do
      transform = Matrix.translation(5, -3, 2)
      p = Point.new(-3, 4, 5)
      assert Matrix.multiply(transform, p) == Point.new(2, 1, 7)
    end

    test "multiplying by the inverse of a translation matrix" do
      transform = Matrix.translation(5, -3, 2)
      inv = Matrix.inverse(transform)
      p = Point.new(-3, 4, 5)
      assert Matrix.multiply(inv, p) == Point.new(-8, 7, 3)
    end

    test "translation does not affect vectors" do
      transform = Matrix.translation(5, -3, 2)
      v = Vector.new(-3, 4, 5)
      assert Matrix.multiply(transform, v) == v
    end
  end

  describe "scaling" do
    test "a scaling matrix applied to a point" do
      transform = Matrix.scaling(2, 3, 4)
      p = Point.new(-4, 6, 8)
      assert Matrix.multiply(transform, p) == Point.new(-8, 18, 32)
    end

    test "a scaling matrix applied to a vector" do
      transform = Matrix.scaling(2, 3, 4)
      v = Vector.new(-4, 6, 8)
      assert Matrix.multiply(transform, v) == Vector.new(-8, 18, 32)
    end

    test "multiplying by the inverse of a scaling matrix" do
      transform = Matrix.scaling(2, 3, 4)
      inv = Matrix.inverse(transform)
      v = Vector.new(-4, 6, 8)
      assert Matrix.multiply(inv, v) == Vector.new(-2, 2, 2)
    end

    test "reflection is scaling by a negative value" do
      transform = Matrix.scaling(-1, 1, 1)
      p = Point.new(2, 3, 4)
      assert Matrix.multiply(transform, p) == Point.new(-2, 3, 4)
    end
  end

  describe "rotation" do
    test "rotating a point around the x axis" do
      p = Point.new(0, 1, 0)
      half_quarter = Matrix.rotation_x(:math.pi() / 4)
      full_quarter = Matrix.rotation_x(:math.pi() / 2)

      assert Tuple.equal?(
               Matrix.multiply(half_quarter, p),
               Point.new(0, :math.sqrt(2) / 2, :math.sqrt(2) / 2)
             )

      assert Tuple.equal?(Matrix.multiply(full_quarter, p), Point.new(0, 0, 1))
    end

    test "the inverse of an x-rotation rotates in the opposite direction" do
      p = Point.new(0, 1, 0)
      half_quarter = Matrix.rotation_x(:math.pi() / 4)
      inv = Matrix.inverse(half_quarter)

      assert Tuple.equal?(
               Matrix.multiply(inv, p),
               Point.new(0, :math.sqrt(2) / 2, -:math.sqrt(2) / 2)
             )
    end

    test "rotating a point around the y axis" do
      p = Point.new(0, 0, 1)
      half_quarter = Matrix.rotation_y(:math.pi() / 4)
      full_quarter = Matrix.rotation_y(:math.pi() / 2)

      assert Tuple.equal?(
               Matrix.multiply(half_quarter, p),
               Point.new(:math.sqrt(2) / 2, 0, :math.sqrt(2) / 2)
             )

      assert Tuple.equal?(Matrix.multiply(full_quarter, p), Point.new(1, 0, 0))
    end

    test "rotating a point around the z axis" do
      p = Point.new(0, 1, 0)
      half_quarter = Matrix.rotation_z(:math.pi() / 4)
      full_quarter = Matrix.rotation_z(:math.pi() / 2)

      assert Tuple.equal?(
               Matrix.multiply(half_quarter, p),
               Point.new(-:math.sqrt(2) / 2, :math.sqrt(2) / 2, 0)
             )

      assert Tuple.equal?(Matrix.multiply(full_quarter, p), Point.new(-1, 0, 0))
    end
  end
end
