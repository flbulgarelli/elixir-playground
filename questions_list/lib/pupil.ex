defmodule Pupil do
  def start(list, notifier) do
    spawn_link fn ->
      QuestionsList.add_pupil list, self
      new {list, notifier}
    end
  end

  defp new(s={list, notifier}) do
    receive do
      {:question, question} -> 
         QuestionsList.make_question(list, question)
      m = {:answer, answer } ->
         send notifier, m
    end
    new s
  end

  def make_question(self, question) do
    send self, {:question, question}
  end

  def accept_answer(self, answer) do
    send self, {:answer, answer}
  end
end
