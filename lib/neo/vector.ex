defmodule Neo.Vector do
  defstruct [:map, :length]

  def dot_product(%__MODULE__{length: l1}, %__MODULE__{length: l2})
  when l1 != l2, do: :error
  def dot_product(%__MODULE__{map: map1, length: l}, %__MODULE__{map: map2}) do
    for i <- 0..(l-1) do
      elem1 = Map.get(map1, i)
      elem2 = Map.get(map2, i)
      if not is_nil(elem1) and not is_nil(elem2), do: elem1 * elem2, else: 0
    end
    |> Enum.sum
  end
end
