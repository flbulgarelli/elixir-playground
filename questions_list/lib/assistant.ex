defmodule Assistant do
  def start(list, notifier) do
    spawn_link fn -> 
      QuestionsList.add_assistant list, self
      new {list, notifier}
    end
  end

  defp new(s = {list, notifier}) do
    receive do
       {:question, sender, question} ->
         send notifier, {:question, sender, question} 
    end
    new s
  end

  def do_answer(self, sender, question) do
    send self, {:question, question}   
  end
end
