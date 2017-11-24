defmodule LinearSystem do
    @moduledoc """
    Functions related to solving a system of linear equations.
    """

    @doc """
    Solves a system of linear equations.
    Each equation is a tuple of two elements: a list of coefficients and a term.
    Returns a list of values for the variables.
    """
    def solve(equations) when is_list(equations) do
        coefficients = for equation <- equations do elem(equation, 0) end
        answers = for equation <- equations do [elem(equation, 1)] end

        IO.inspect(coefficients, charlists: :as_list)
        inverse = Matrix.inv(coefficients)
        if inverse == nil do
            nil
        else
            inverse
            |> Matrix.mul(answers)
            |> List.flatten()
        end
    end
end
