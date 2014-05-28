defmodule AssistantTest do
  use ExUnit.Case

  test "forwards questions to list" do
    assistant = Assistant.start SyncActor.start(:added), self

    Assistant.request_answer assistant, "foo?"

    assert_receive {:question, assistant, "foo?"}, 1000
  end

  test "notifies accepted answers" do
    assistant = Assistant.start MiddleManActor.start(SyncActor.start(:added), self), DeafActor.start

    Assistant.do_answer assistant, "foo"

    assert_receive {:answer, "foo"}
  end

end
