import Tree, only: [spawn_node: 1]

ExUnit.start

defmodule TreeTest do
  use ExUnit.Case

  test "can insert elements" do
    root = spawn_node(1)

    send root, {:insert, 3, self()}

    assert_receive :ok
  end

  test "can insert multiple elements" do 
     root = spawn_node(10)

     send root, {:insert, 3, self()}
     send root, {:insert, 4, self()}
     send root, {:insert, 30, self()}

     assert_receive :ok
     assert_receive :ok
     assert_receive :ok
  end

  test "can traverse a single node" do
    root = spawn_node(10)

    send root, {:traverse, self()}

    assert_receive {:found, 10}
  end 

  test "can traverse a whole tree" do
    root = spawn_node(10)
    send root, {:insert, 3, self()}
    send root, {:insert, 4, self()}
    send root, {:insert, 30, self()}

    send root, {:traverse, self()}

    assert_receive {:found, 10}
    assert_receive {:found, 3}
    assert_receive {:found, 4}
    assert_receive {:found, 30}

  end
end
