defmodule Moderator do
  def start(receiver) do
    spawn_link fn -> loop({receiver, []}) end
  end

  defp loop(s={receiver, refs}) do 
    receive do
       m = {ref, _} -> 
         unless Enum.member? refs, ref do 
           send receiver, m
           loop {receiver, [ref|refs]}
         else
           loop s
         end
    end
  end
end
