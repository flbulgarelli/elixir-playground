ExUnit.start

defmodule DeafActor do
  def start do
    spawn fn -> loop end
  end

  defp loop do
    receive do
    end
    loop
  end
end

defmodule SyncActor do
  def start(confirmation) do
    spawn fn -> loop confirmation end
  end
  defp loop(confirmation) do
    receive do
      {_, _, sender} -> send sender, confirmation
    end
  end
end

defmodule MiddleManActor do
  def start(actor, middle) do
    spawn fn -> loop actor, middle end
  end
  defp loop(actor, middle) do
     receive do
       m -> 
         send middle, m  
         send actor, m
     end
     loop actor, middle
  end
end
