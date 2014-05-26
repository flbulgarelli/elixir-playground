defmodule QuestionsList do
  def start do
    spawn_link fn -> new {[], []} end
  end

  defp new(s = {pupils, assistants}) do
     receive do 
       {:add_pupil, pupil} -> 
           new {[pupil|pupils], assistants}
       {:add_assistant, assistant} ->
           new {pupils, [assistant|assistants]}
       {:question, question} ->
           Enum.each assistants, &Assistant.do_answer(&1, question)
           new s
       {:answer, answer} ->
           Enum.each pupils, &Pupil.accept_answer(&1, answer)
           new s
      end
  end

  def add_pupil(self, pupil) do
    send self, {:add_pupil, pupil}
  end

  def add_assistant(self, assistant) do
    send self, {:add_assistant, assistant}
  end

  def make_question(self, question) do
    send self, {:question, question}
  end

  def accept_answer(self, answer) do
    send self, {:answer, answer}
  end
end
