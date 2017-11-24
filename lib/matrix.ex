defmodule Matrix do
    @moduledoc """
    Functions for matrix operations and manipulations.
    """

    @doc """
    Validates that a 2D array is a valid matrix.
    Returns `true` if valid, `false` if not.
    """
    def valid?(values) do
        is_list(values)
        and Enum.all?(values, fn row ->
            is_list(row)
            and length(row) == length(hd(values))
            and Enum.all?(row, &is_number/1)
        end)
    end

    @doc """
    Multiplies a matrix by a scalar.
    Returns a new matrix.
    """
    def mul(scalar, matrix) when is_number(scalar) and is_list(matrix) do
        for row <- matrix do
            for entry <- row do scalar * entry end
        end
    end

    @doc """
    Multiplies a matrix by a matrix.
    Returns a new matrix.
    """
    def mul(matrix_a, matrix_b) when is_list(matrix_a) and is_list(matrix_b) do
        if Matrix.columns(matrix_a) != Matrix.rows(matrix_b) do
            raise ArithmeticError, message: "matrices are incompatible for multiplication"
        end

        rows = matrix_a
        columns = 0..(Matrix.columns(matrix_b) - 1)
        |> Enum.map(fn i -> 
            for row <- matrix_b do Enum.at(row, i) end
        end)

        for row <- rows do
            for column <- columns do
                for i <- 0..(length(row) - 1) do
                    Enum.at(row, i) * Enum.at(column, i)
                end
                |> Enum.reduce(fn (n, acc) -> acc + n end)
            end
        end
    end

    @doc """
    Evaluates the determinant of a matrix.
    Returns a number.
    """
    def det(matrix) when is_list(matrix) do
        if Matrix.rows(matrix) != Matrix.columns(matrix) do
            raise ArithmeticError, message: "cannot evaluate determinant of non-square matrix"
        end

        if Matrix.rows(matrix) == 2 and Matrix.columns(matrix) == 2 do
            row_a = hd(matrix)
            row_b = List.last(matrix)
            Enum.at(row_a, 0) * Enum.at(row_b, 1) - Enum.at(row_a, 1) * Enum.at(row_b, 0)
        else
            determinants = for i <- 0..(Matrix.columns(matrix) - 1) do
                n = Enum.at(hd(matrix), i)
                section = for row <- tl(matrix) do
                    List.delete_at(row, i)
                end
                |> Matrix.det()
                n * section
            end

            negatives = tl(determinants)
            |> Enum.take_every(2)
            |> Enum.map(fn n -> -n end)

            positives = determinants
            |> Enum.take_every(2)

            negatives ++ positives
            |> Enum.reduce(fn (n, acc) -> acc + n end)
        end
    end

    @doc """
    Evaluates the inverse of a matrix.
    Returns a matrix.
    """
    def inv(matrix) when is_list(matrix) do
        if Matrix.rows(matrix) != Matrix.columns(matrix) do
            raise ArithmeticError, message: "cannot evaluate inverse of non-square matrix"
        end

        minors = Matrix.minors(matrix)
        cofactors = Matrix.cofactors(minors)
        adjugate = Matrix.transpose(cofactors)
        determinant = Matrix.det(matrix)

        if determinant == 0 do
            nil
        else
            1 / determinant
            |> Matrix.mul(adjugate)
        end
    end

    @doc """
    Evaluates the matrix of minors of a matrix.
    Returns a matrix.
    """
    def minors(matrix) when is_list(matrix) do
        if Matrix.rows(matrix) != Matrix.columns(matrix) do
            raise ArithmeticError, message: "cannot evaluate matrix of minors of non-square matrix"
        end

        for row_i <- 0..(length(matrix) - 1) do
            row = Enum.at(matrix, row_i)
            for entry_i <- 0..(length(row) - 1) do
                for sig_row <- List.delete_at(matrix, row_i) do
                    List.delete_at(sig_row, entry_i)
                end
                |> Matrix.det()
            end
        end
    end

    @doc """
    Evaluates the matrix of cofactors of a matrix.
    Returns a matrix.
    """
    def cofactors(matrix) when is_list(matrix) do
        if Matrix.rows(matrix) != Matrix.columns(matrix) do
            raise ArithmeticError, message: "cannot evaluate matrix of cofactors of non-square matrix"
        end

        [0 | matrix]
        |> List.flatten()
        |> Enum.map_every(2, fn n -> -n end)
        |> List.delete_at(0)
        |> Enum.chunk_every(Matrix.columns(matrix))
    end

    @doc """
    Transposes a matrix.
    Returns a matrix.
    """
    def transpose(matrix) when is_list(matrix) do
        0..(Matrix.columns(matrix) - 1)
        |> Enum.map(fn i -> 
            for row <- matrix do Enum.at(row, i) end
        end)
    end

    @doc """
    Gets the amount of rows of a matrix.
    Returns an integer.
    """
    def rows(matrix) when is_list(matrix) do
        length(matrix)
    end

    @doc """
    Gets the amount of columns of a matrix.
    Returns an integer.
    """
    def columns(matrix) when is_list(matrix) do
        length(hd(matrix))
    end
end
