import Tree, only: [spawn_node: 1, empty: 0]

ExUnit.start

defmodule TreeTest do
  use ExUnit.Case
  
  test "can create empty tree" do
    tree = spawn_link fn -> empty end
    
    send tree, {:traverse, self}
    
    refute_receive {:found, _}
  end

  test "can insert elements into tree" do
    tree = spawn_link fn -> empty end
   
    send tree, {:insert, 3, self}
    send tree, {:insert, 4, self}
    send tree, {:traverse, self}   

    assert_receive {:found, 3}
    assert_receive {:found, 4}
  end 
end

defmodule NodeTest do
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
