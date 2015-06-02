# Events

This example shows how does the asynchronous events and message passing take place on Elixir.

We have a hotel were we have guests and we want to send events that can be to add or confirm a guest.

When we send an event to add or confirm a guest, upon finalization of the operation the receiving process that will handle the event,
sends another event with the response guest_added or guest_confirmed, that will be the response sent to the original sender, so we can see
this as message passing from one end that can be a manager (original sender) and a clerk (receptor and person that will handle the event).
