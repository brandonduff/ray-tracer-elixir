defmodule RayTracerElixir.Components do
  @callback components(any) :: [float]
  @callback new(any) :: any
end

defmodule RayTracerElixir.ComponentOperations do
  alias __MODULE__

  defmacro __using__(_) do
    quote do
      def add(a, b) do
        zip_components(a, b, &Kernel.+/2) |> new()
      end

      def subtract(a, b) do
        zip_components(a, b, &Kernel.-/2) |> new()
      end

      def negate(tuple) do
        subtract(new([0, 0, 0, 0]), tuple)
      end

      def multiply(tuple, scalar) when is_number(scalar) do
        map_components(tuple, fn c -> c * scalar end)
      end

      def divide(tuple, scalar) do
        map_components(tuple, fn c -> c / scalar end)
      end

      def equal?(a, b) do
        zip_components(a, b, fn c1, c2 -> ComponentOperations.close?(c1, c2) end) |> Enum.all?()
      end

      defp map_components(tuple, func) do
        apply(__MODULE__, :new, Enum.map(components(tuple), func))
      end

      defp zip_components(a, b, func) do
        Enum.zip_with(components(a), components(b), func)
      end

      defp reduce_components(tuple, func) do
        Enum.reduce(components(tuple), func)
      end
    end
  end

  def close?(a, b) do
    abs(a - b) < 0.00001
  end
end
