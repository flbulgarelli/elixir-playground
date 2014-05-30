defmodule Assistant do
  def start(list, notifier, moderator) do
    creator = self
    assistant = spawn_link fn -> 
      QuestionsList.add_assistant list, self, creator
      new {list, notifier, moderator}
    end
    receive do
      :added -> assistant
    after 
       1000 -> raise "not ready"
    end
  end

  defp new(s = {list, notifier, moderator}) do
    receive do
       {ref, {:question, question}} ->
         send notifier, {ref, {:question, self, question}} 
       {ref, {:answer, answer}} ->  
         QuestionsList.accept_answer moderator, ref, answer
    end
    new s
  end

  def request_answer(self, ref, question) do
    send self, {ref, {:question, question}}   
  end

  def do_answer(self, ref, answer) do
    send self, {ref, {:answer, answer}}
  end

end
