defmodule QuestionsListTest do
  use ExUnit.Case

  defmodule AnsweringMock do
    def start(fixed_answer) do
      spawn_link fn -> answer_fixed fixed_answer end
    end

    defp answer_fixed(fixed_answer) do
      receive do
        {:question, list, _ } -> 
           QuestionsList.accept_answer(list, fixed_answer)
      end
      answer_fixed(fixed_answer)
    end
  end

  test "receives answers" do
    l = QuestionsList.start
    pupil = Pupil.start l, self
    assistant_1 = Assistant.start l, AnsweringMock.start(1)
    assistant_2 = Assistant.start l, AnsweringMock.start(2)

    Pupil.make_question pupil, :a_question
    
    assert_receive {:answer, 1}, 1000
    assert_receive {:answer, 2}, 1000
  end


end
