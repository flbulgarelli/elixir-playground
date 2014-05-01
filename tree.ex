defmodule Tree do
  def spawn_node(value) do
     spawn fn -> tree_node({value, nil, nil}) end
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
         unless left == nil do
           send left, {:traverse, who}
         end
         unless right == nil do
           send right, {:traverse, who}
         end
         s           
    end
    tree_node(new_s)
  end

  defp insert_left({value, left, right}, what, who) do
    if left == nil do
      new_left = spawn_link fn -> tree_node({what, nil, nil}) end
      send who, :ok
      {value, new_left, right}
    else 
      send left, {:insert, what, who }
      {value, left, right} 
    end
  end

  defp insert_right(s, what, who) do
    case s do
      {value, left, nil} -> 
         right =  spawn_link fn -> tree_node({what, nil, nil}) end
         send who, :ok
         {value, left, right}
      {_, _, right}  -> 
         send right, {:insert, what, who }
         s
    end
  end
end

	
