import EtsStore
import ListSearch

defmodule ListSearchTest do
  use ExUnit.Case

  test "Search pattern on empty list" do
    list = []
    assert ListSearch.search_pattern(list, 2) == {:error, :none_found}
  end

  test "Search inexistent value on list" do
    list = [1,2,4,8,16,32]
    assert ListSearch.search_pattern(list, 31) == {:error, :none_found}
  end

  test "Search existent value on list" do
    list = [1,2,4,8,16,32]
    assert ListSearch.search_pattern(list, 4) == {:ok, 4}
  end

end

defmodule EtsStoreTest do
  use ExUnit.Case

  test "add table and check if the tables are defined or not" do
    EtsStore.new_table(:onetable)
    assert EtsStore.is_table_defined(:onetable) == {:ok, :onetable}
    assert EtsStore.is_table_defined(:some_table) == {:error, :none_found}
  end

  test "initialize, set 1 and get it" do
    EtsStore.new_table(:some_table)
    EtsStore.put(:some_table, "one", 1)

    assert EtsStore.get(:some_table, "one") == {:ok, 1}
  end

  test "set multiple and get" do
    EtsStore.new_table(:some_table)
    assert EtsStore.is_table_defined(:some_table) == {:ok, :some_table}
    EtsStore.put(:some_table, "one", 1)
    EtsStore.put(:some_table, :two, 2)

    assert EtsStore.get(:some_table, "two") == {:error, :not_found}
    assert EtsStore.get(:some_table, :two) == {:ok, 2}
  end

  test "set and delete" do
    EtsStore.new_table(:some_table)
    EtsStore.put(:some_table, :something, "something")

    assert EtsStore.get(:some_table, :something) == {:ok, "something"}

    assert EtsStore.delete(:some_table, :something)
    assert EtsStore.get(:some_table, :something) == {:error, :not_found}
  end

  test "set and update" do
    EtsStore.new_table(:some_table)
    EtsStore.put(:some_table, :one, 1)

    assert EtsStore.get(:some_table, :one) == {:ok, 1}

    EtsStore.update(:some_table, :one, "one")
    assert EtsStore.get(:some_table, :one) == {:ok, "one"}
  end

end
