defmodule Neo.Matrix do
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
end
