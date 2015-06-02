import EtsStore

defmodule EtsStoreTest do
  use ExUnit.Case

  test "initialize, set 1 and get it" do
    EtsStore.init
    EtsStore.insert("one", 1)

    assert EtsStore.get("one") == {:ok, 1}
  end

  test "set multiple and get" do
    EtsStore.init
    EtsStore.insert("one", 1)
    EtsStore.insert(:two, 2)

    assert EtsStore.get("two") == {:error, :not_found}
    assert EtsStore.get(:two) == {:ok, 2}
  end

  test "set and delete" do
    EtsStore.init
    EtsStore.insert(:something, "something")

    assert EtsStore.get(:something) == {:ok, "something"}

    assert EtsStore.delete(:something)
    assert EtsStore.get(:something) == {:error, :not_found}
  end

  test "set and update" do
    EtsStore.init
    EtsStore.insert(:one, 1)

    assert EtsStore.get(:one) == {:ok, 1}

    EtsStore.update(:one, "one")
    assert EtsStore.get(:one) == {:ok, "one"}
  end
end
