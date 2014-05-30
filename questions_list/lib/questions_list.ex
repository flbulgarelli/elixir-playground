defmodule QuestionsList do
  def start do
    spawn_link fn -> new {[], []} end
  end

  defp new(s = {pupils, assistants}) do
     receive do 
       {:add_pupil, pupil} -> 
           new {[pupil|pupils], assistants}
       {:add_assistant, assistant, creator} ->
           send creator, :added
           new {pupils, [assistant|assistants]}
       {ref, {:question, question}} ->
           Enum.each assistants, &Assistant.request_answer(&1, ref, question)
           new s
       {ref, {:answer, answer}} ->
           Enum.each pupils, &Pupil.accept_answer(&1, ref, answer)
           new s
      end
  end

  def add_pupil(self, pupil) do
    send self, {:add_pupil, pupil}
  end

  def add_assistant(self, assistant, creator) do
    send self, {:add_assistant, assistant, creator}
  end

  def make_question(self, ref, question) do
    send self, {ref, {:question, question}}
  end

  def accept_answer(self, ref, answer) do
    send self, {ref, {:answer, answer}}
  end
end
