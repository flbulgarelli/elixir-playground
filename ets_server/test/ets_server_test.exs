defmodule EtsServerTest do
  use ExUnit.Case

  setup do
    {:ok, key_value} = EtsServer.start_link
    {:ok, key_value: key_value}
  end


  test "Create table and check it exists", %{key_value: key_value} do
    GenServer.cast(key_value, {:create_table, :atable})
    assert GenServer.call(key_value, {:is_table_defined, :atable}) == :atable
    assert GenServer.call(key_value, {:is_table_defined, :undefined_table}) == {:error, :none_found}
  end

  test "Create table, put a value and retrieve it", %{key_value: key_value} do
    GenServer.cast(key_value, {:create_table, :atable})
    assert GenServer.call(key_value, {:is_table_defined, :atable}) == :atable
    assert GenServer.call(key_value, {:put, :atable, :a_value, 1}) == true
    assert GenServer.call(key_value, {:get, :atable, :a_value}) == 1
  end

  test "Create table, put a value, retrieve it and then delete it", %{key_value: key_value} do
    GenServer.cast(key_value, {:create_table, :atable})
    assert GenServer.call(key_value, {:is_table_defined, :atable}) == :atable
    assert GenServer.call(key_value, {:put, :atable, :a_value, 1}) == true
    assert GenServer.call(key_value, {:get, :atable, :a_value}) == 1
    GenServer.cast(key_value, {:delete, :atable, :a_value})
    assert GenServer.call(key_value, {:get, :atable, :a_value}) == {:error, :failed_get_ets}
  end

  test "Create table, put a value, update it", %{key_value: key_value} do
    GenServer.cast(key_value, {:create_table, :atable})
    assert GenServer.call(key_value, {:is_table_defined, :atable}) == :atable
    assert GenServer.call(key_value, {:put, :atable, :a_value, 1}) == true
    GenServer.call(key_value, {:update, :atable, :a_value, 2})
    assert GenServer.call(key_value, {:get, :atable, :a_value}) == 2
  end

end
