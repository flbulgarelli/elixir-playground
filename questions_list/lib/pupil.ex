defmodule Pupil do
  def start(list, notifier) do
    spawn_link fn ->
      QuestionsList.add_pupil list, self
      new {list, notifier}
    end
  end

  defp new(s={list, notifier}) do
    receive do
      {ref, {:question, question}} -> 
         QuestionsList.make_question list, ref, question
      m = {ref, {:answer, answer }} ->
         send notifier, m
    end
    new s
  end

  def make_question(self, question) do
    send self, {make_ref, {:question, question}}
  end

  def accept_answer(self, ref, answer) do
    send self, {ref, {:answer, answer}}
  end
end
