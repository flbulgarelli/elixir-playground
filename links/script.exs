import F

f = loopf fn -> 
 receive do
   :quit -> exit :shutdown
   :done -> exit :normal
  end
end

s = self
g = fn -> 
  x = spawn_link f
  y = spawn_link f
  z = spawn_link f
  loop fn ->
    receive do 
     :links -> send s, {x, y, z}
     :quit -> exit :shutdown
     :done -> exit :normal
    end
  end
end

p = spawn g

send p, :links
receive do
  m -> {x, y, z} = m
after 2000 ->
  raise "something went wrong"
end
Process.alive? x
Process.alive? y
Process.alive? z
