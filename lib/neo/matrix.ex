defmodule Neo.Matrix do
  use Dict

  defstruct [:map, :rows, :cols]

  def delete(%__MODULE__{rows: rows, cols: cols}, {row, col})
  when row >= rows or col >= cols do
    :error
  end
  def delete(%__MODULE__{map: map} = matrix, {row, col}) do
    cols =
      case Map.fetch(map, row) do
        {:ok, cols} ->
          Enum.into(cols, %{})
          |> Map.delete(col)
          |> Enum.into([])
        :error -> []
      end
    if cols == [] do
      {:ok, %{matrix | map: Map.delete(map, row)}}
    else
      {:ok, %{matrix | map: Map.put(map, row, cols)}}
    end
  end

  def fetch(%__MODULE__{rows: rows, cols: cols}, {row, col})
  when row >= rows or col >= cols do
    :error
  end
  def fetch(%__MODULE__{map: map}, {row, col}) do
    case Map.fetch(map, row) do
      {:ok, cols} ->
        Enum.into(cols, %{})
        |> Map.fetch(col)
      :error -> :error
    end
  end

  def new() do
    %__MODULE__{map: %{}, rows: 0, cols: 0}
  end

  def new(rows, cols) do
    %__MODULE__{map: %{}, rows: rows, cols: cols}
  end

  def put(%__MODULE__{rows: rows, cols: cols}, {row, col}, _)
  when row >= rows or col >= cols do
    :error
  end
  def put(%__MODULE__{map: map} = matrix, {row, col}, val) do
    cols = [{col, val} | get_row(matrix, row)]
    {:ok, %{matrix | map: Map.put(map, row, cols)}}
  end

  def reduce(%__MODULE__{map: map}, acc, fun) do
    Enum.reduce(map, acc, fun)
  end

  def size(%__MODULE__{rows: rows, cols: cols}) do
    {rows, cols}
  end

  defp get_row(%__MODULE__{map: map}, row) do
    case Map.fetch(map, row) do
      {:ok, cols} when is_list(cols) -> cols
      :error -> []
    end
  end
end
