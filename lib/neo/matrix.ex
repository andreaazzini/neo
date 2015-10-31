defmodule Neo.Matrix do
  alias Neo.Vector

  defstruct [:map, :rows, :cols]

  def delete(%__MODULE__{rows: rows, cols: cols}, {row, col})
  when row >= rows or col >= cols, do: :error
  def delete(%__MODULE__{map: map} = matrix, {row, col}) do
    %{matrix | map: Map.delete(map, {row, col})}
  end

  def get(%__MODULE__{rows: rows, cols: cols}, {row, col})
  when row >= rows or col >= cols, do: :error
  def get(%__MODULE__{map: map}, {row, col}) do
    case Map.fetch(map, {row, col}) do
      {:ok, val} -> val
      :error -> nil
    end
  end

  def fetch(%__MODULE__{rows: rows, cols: cols}, {row, col})
  when row >= rows or col >= cols, do: :error
  def fetch(%__MODULE__{map: map}, {row, col}) do
    Map.fetch(map, {row, col})
  end

  def new(), do: %__MODULE__{map: %{}, rows: 0, cols: 0}

  def new(rows, cols), do: %__MODULE__{map: %{}, rows: rows, cols: cols}

  def put(%__MODULE__{rows: rows, cols: cols}, {row, col}, _)
  when row >= rows or col >= cols, do: :error
  def put(%__MODULE__{map: map} = matrix, {row, col}, val) do
    %{matrix | map: Map.put(map, {row, col}, val)}
  end

  def size(%__MODULE__{rows: rows, cols: cols}), do: {rows, cols}

  def transpose(%__MODULE__{map: map, rows: rows, cols: cols}) do
    trans_map =
      Enum.map(map, fn {{row, col}, val} -> {{col, row}, val} end)
      |> Enum.into(%{})
    %__MODULE__{map: trans_map, rows: cols, cols: rows}
  end

  def multiply(%__MODULE__{cols: cols}, %__MODULE__{rows: rows})
  when cols != rows, do: :error
  def multiply(%__MODULE__{rows: rows} = matrix1, %__MODULE__{cols: cols} = matrix2) do
    map =
      for i <- 0..(rows-1) do
        for j <- 0..(cols-1) do
          row = row_at(matrix1, i) |> vectorize(:row)
          col = col_at(matrix2, j) |> vectorize(:col)
          val = Vector.dot_product(row, col)
          {{i, j}, val}
        end
      end
      |> Enum.flat_map(&(&1))
      |> Enum.filter(fn {_, val} -> val != 0 end)
      |> Enum.into(%{})
    %__MODULE__{map: map, rows: rows, cols: cols}
  end

  defp vectorize(%__MODULE__{map: map, cols: cols}, :row) do
    vector_map =
      Enum.map(map, fn {{_, col}, val} -> {col, val} end)
      |> Enum.into(%{})
    %Vector{map: vector_map, length: cols}
  end
  defp vectorize(%__MODULE__{map: map, rows: rows}, :col) do
    vector_map =
      Enum.map(map, fn {{row, _}, val} -> {row, val} end)
      |> Enum.into(%{})
    %Vector{map: vector_map, length: rows}
  end

  defp row_at(%__MODULE__{map: map} = matrix, index) do
    row_map =
      Enum.filter(map, fn {{row, _}, _} -> row == index end)
      |> Enum.into(%{})
    %{matrix | map: row_map}
  end

  defp col_at(%__MODULE__{map: map} = matrix, index) do
    col_map =
      Enum.filter(map, fn {{_, col}, _} -> col == index end)
      |> Enum.into(%{})
    %{matrix | map: col_map}
  end
end
