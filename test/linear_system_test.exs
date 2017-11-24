defmodule LinearSystemTest do
    use ExUnit.Case
    doctest LinearSystem
    doctest Matrix

    test "recognizes a matrix" do
        matrix = [
            [1, 2, 3],
            [4, 5, 6]
        ]

        assert(Matrix.valid?(matrix) and Matrix.rows(matrix) == 2 and Matrix.columns(matrix) == 3)
    end

    test "multiplies a matrix by a scalar" do
        matrix = [
            [1, 2],
            [4, 5]
        ]

        product = Matrix.mul(5, matrix)
        assert(product == [
            [5, 10],
            [20, 25]
        ])
    end

    test "multiplies a matrix by a matrix" do
        matrix_a = [
            [1, 4, 5, 12],
            [7, 6, 3, 3]
        ]

        matrix_b = [
            [8, 5],
            [3, 4],
            [5, 1],
            [9, 13]
        ]

        product = Matrix.mul(matrix_a, matrix_b)
        assert(product == [
            [153, 182],
            [116, 101]
        ])
    end

    test "evaluates determinant of a 2x2 matrix" do
        matrix = [
            [4, 6],
            [3, 8]
        ]

        assert(Matrix.det(matrix) == 14)
    end

    test "evaluates determinant of a 4x4 matrix" do
        matrix = [
            [1, 2, 3, 4],
            [5, 6, 7, 8],
            [9, 4, 5, 6],
            [2, 3, 4, 7]
        ]

        assert(Matrix.det(matrix) == -48)
    end

    test "evalutes matrix of minors of a 3x3 matrix" do
        matrix = [
            [3, 0, 2],
            [2, 0, -2],
            [0, 1, 1]
        ]

        assert(Matrix.minors(matrix) == [
            [2, 2, 2],
            [-2, 3, 3],
            [0, -10, 0]
        ])
    end

    test "evaluates matrix of cofactors of a 3x3 matrix" do
        matrix = [
            [1, -2, 3],
            [4, -5, -6],
            [7, 8, -9]
        ]

        assert(Matrix.cofactors(matrix) == [
            [1, 2, 3],
            [-4, -5, 6],
            [7, -8, -9]
        ])
    end

    test "tranposes a 3x3 matrix" do
        matrix = [
            [1, -2, 3],
            [4, -5, -6],
            [7, 8, -9]
        ]

        assert(Matrix.transpose(matrix) == [
            [1, 4, 7],
            [-2, -5, 8],
            [3, -6, -9]
        ])
    end

    test "tranposes a 2x3 matrix" do
        matrix = [
            [6, 4, 24],
            [1, -9, 8]
        ]

        assert(Matrix.transpose(matrix) == [
            [6, 1],
            [4, -9],
            [24, 8]
        ])
    end

    test "evalutes inverse of a 3x3 matrix" do
        matrix = [
            [2, 0, 2],
            [2, 0, -2],
            [0, 4, 4]
        ]

        assert(Matrix.inv(matrix) == [
            [0.25, 0.25, 0],
            [-0.25, 0.25, 0.25],
            [0.25, -0.25, 0]
        ])
    end

    test "solves a system of linear equations" do
        solution = LinearSystem.solve([
            { [1, 1, 1], 6 },
            { [0, 2, 5], -4 },
            { [2, 5, -1], 27 }
        ])

        assert(solution == [4.999999999999999, 3.0, -1.9999999999999998])
    end
end
