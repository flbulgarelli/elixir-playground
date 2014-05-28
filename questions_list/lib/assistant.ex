defmodule Assistant do
  def start(list, notifier) do
    creator = self
    assistant = spawn_link fn -> 
      QuestionsList.add_assistant list, self, creator
      new {list, notifier}
    end
    receive do
      :added -> assistant
    after 
       1000 -> raise "not ready"
    end
  end

  defp new(s = {list, notifier}) do
    receive do
       {:question, question} ->
         send notifier, {:question, self, question} 
       {:answer, answer} ->  
         QuestionsList.accept_answer list, answer
    end
    new s
  end

  def request_answer(self, question) do
    send self, {:question, question}   
  end

  def do_answer(self, answer) do
    send self, {:answer, answer}
  end

end
