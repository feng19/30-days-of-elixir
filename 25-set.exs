ExUnit.start

defmodule SetTest do
  use ExUnit.Case

  test "to_list" do
    list = Enum.into([1, 2, 2, 3], MapSet.new) |> MapSet.to_list
    assert list == [1, 2, 3] # unintuitive ordering
  end

  test "union" do
    union = Enum.into([1, 2, 3], MapSet.new) |> MapSet.union(Enum.into([2, 3, 4], MapSet.new))
    assert Set.to_list(union) == [1, 2, 3, 4] # unintuitive, but somewhat more understandable
  end

  test "intersection" do
    union = Enum.into([1, 2, 3], MapSet.new) |> MapSet.intersection(Enum.into([2, 3, 4], MapSet.new))
    assert Set.to_list(union) == [2, 3]
  end

  test "member?" do
    refute Enum.into([1, 3, 5], MapSet.new) |> MapSet.member?(2)
  end
end
