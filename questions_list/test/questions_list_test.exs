defmodule QuestionsListTest do
  use ExUnit.Case

  defmodule AnsweringMock do
    def start(fixed_answer) do
      spawn_link fn -> answer_fixed fixed_answer end
    end

    defp answer_fixed(fixed_answer) do
      receive do
        {:question, assistant, _ } -> 
           Assistant.do_answer(assistant, fixed_answer)
      end
      answer_fixed(fixed_answer)
    end
  end

  test "answers notifier receives answers" do
    l = QuestionsList.start
    pupil = Pupil.start l, self
    assistant_1 = Assistant.start l, AnsweringMock.start(1)
    assistant_2 = Assistant.start l, AnsweringMock.start(2)

    Pupil.make_question pupil, :a_question
    
    assert_receive {:answer, 1}, 1000
    assert_receive {:answer, 2}, 1000
  end


  test "question notifier receives questions" do
    l = QuestionsList.start
    pupil = Pupil.start l, DeafActor.start
    assistant = Assistant.start l, self

    Pupil.make_question pupil, :a_question
    
    assert_receive _, 1000
  end

  test "pupil questiosn are forwarded to assistants" do
    l = QuestionsList.start
    pupil = Pupil.start l, DeafActor.start
    QuestionsList.add_assistant l, self, self
    
    Pupil.make_question pupil, "foo?"
    
    assert_receive {:question, "foo?" }
  end

end
