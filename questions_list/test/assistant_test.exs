defmodule AssistantTest do
  use ExUnit.Case

  test "forwards questions to list" do
    l = SyncActor.start(:added)
    assistant = Assistant.start l, self, l
    r = make_ref

    Assistant.request_answer assistant, r, "foo?"

    assert_receive {^r, {:question, assistant, "foo?"}}, 1000
  end

  test "notifies accepted answers" do
    l = MiddleManActor.start(SyncActor.start(:added), self)
    assistant = Assistant.start l, DeafActor.start, l
    r = make_ref

    Assistant.do_answer assistant, r, "foo"

    assert_receive {^r, {:answer, "foo"}}
  end

end
