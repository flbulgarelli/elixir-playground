defmodule Event do
   def create_event(s = {name, guests}) do
     receive do
       {:add_guest,  guest, who} ->
         new_guests = [guest|guests]
         send guest, {:guest_added, self}
         send who, :ok
         create_event({name, new_guests})
       {:get_guests, who} ->
         send_guests(guests, who)
         create_event(s)
       {:confirm, who} ->
         send_guests(guests, who)
         Enum.each guests, &(send &1, {:guest_confirmed, self})
         send who, :ok
     end
   end

   defp send_guests(guests, who) do
     send who, {:guests, guests}
   end
 

end
