import Event

defmodule EventTest do
  use ExUnit.Case

  test "guest can be added" do
    event = spawn_link fn -> create_event {"foo", [] } end
    send event, {:add_guest, self, self }

    assert_receive {:guest_added, ^event }
  end
  
  test "event can be forcively confirmed" do
    event = spawn_link fn -> create_event {"foo", [] } end
    send event, {:add_guest, self, self }

    send event, {:confirm, self }

    assert_receive {:guest_confirmed, ^event }
  end
  
end
