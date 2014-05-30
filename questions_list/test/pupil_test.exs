defmodule PupilTest do
  use ExUnit.Case

  test "forwards questions to list" do
    pupil = Pupil.start self, nil

    Pupil.make_question pupil, "foo"

    assert_receive {_, {:question, "foo"}}, 1000
  end

  test "notifies accepted answers" do
    pupil = Pupil.start DeafActor.start, self

    Pupil.accept_answer pupil, make_ref, "foo"

    assert_receive {_, {:answer, "foo" }}
  end

end
