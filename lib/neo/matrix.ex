defmodule Neo.Matrix do
  use Dict

  defstruct [:map, :rows, :cols]

  def delete(%__MODULE__{rows: rows, cols: cols}, {row, col})
  when row >= rows or col >= cols do
    :error
  end
  def delete(%__MODULE__{map: map} = matrix, {row, col}) do
    %{matrix | map: Map.delete(map, {row, col})}
  end

  def fetch(%__MODULE__{rows: rows, cols: cols}, {row, col})
  when row >= rows or col >= cols do
    :error
  end
  def fetch(%__MODULE__{map: map}, {row, col}) do
    Map.fetch(map, {row, col})
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
    %{matrix | map: Map.put(map, {row, col}, val)}
  end

  def reduce(%__MODULE__{map: map}, acc, fun) do
    Enum.reduce(map, acc, fun)
  end

  def size(%__MODULE__{rows: rows, cols: cols}) do
    {rows, cols}
  end
end
