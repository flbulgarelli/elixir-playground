defmodule Tree do
 
  def spawn_node(value) do
    spawn_link fn -> new_node(value) end
  end
  
  def new_node(value) do
     tree_node({value, nil, nil})
  end
  
  def tree_node(s = {value, left, right}) do
    new_s = receive do
      {:insert, what, who} -> 
         if what <= value do
           insert_left(s, what, who)
         else 
           insert_right(s, what, who)
         end 
      {:traverse, who} ->
         send who, {:found, value}
         traverse_at left, who
         traverse_at right, who  
         s           
    end
    tree_node(new_s)
  end
  
  defp traverse_at where, who do
    unless where == nil do
      send where, {:traverse, who}
    end
  end

  defp insert_left(s = {value, left, right}, what, who) do
    insert_at s, what, left, who, fn new_left ->
      {value, new_left, right}
    end
  end

  defp insert_right(s = {value, left, right}, what, who) do
    insert_at s, what, right, who, fn new_right ->
      {value, left, new_right} 
    end
  end

  defp insert_at(s, what, where, who, how) do
    if where == nil do
      new_node = spawn_node(what)
      send who, :ok
      how.(new_node)
    else
      send where, {:insert, what, who}
      s
    end
  end  
end

	
