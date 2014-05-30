defmodule QuestionsListTest do
  use ExUnit.Case

  defmodule AnsweringMock do
    def start(fixed_answer) do
      spawn_link fn -> answer_fixed fixed_answer end
    end

    defp answer_fixed(fixed_answer) do
      receive do
        {ref, {:question, assistant, _ }} -> 
           Assistant.do_answer assistant, ref, fixed_answer
      end
      answer_fixed fixed_answer
    end
  end

  test "answers notifier receives answers" do
    l = QuestionsList.start
    pupil = Pupil.start l, self
    assistant_1 = Assistant.start l, AnsweringMock.start(1), l

    Pupil.make_question pupil, :a_question
    
    assert_receive {_, {:answer, 1}}, 1000
  end


  test "question notifier receives questions" do
    l = QuestionsList.start
    pupil = Pupil.start l, DeafActor.start
    assistant = Assistant.start l, self, l

    Pupil.make_question pupil, :a_question
    
    assert_receive _, 1000
  end

  test "pupil questiosn are forwarded to assistants" do
    l = QuestionsList.start
    pupil = Pupil.start l, DeafActor.start
    QuestionsList.add_assistant l, self, self
    
    Pupil.make_question pupil, "foo?"
    
    assert_receive {_, {:question, "foo?" }}
  end

  test "filters duplicated answers" do
    l = QuestionsList.start
    pupil = Pupil.start l, self
    m = Moderator.start l
    assistant_1 = Assistant.start l, AnsweringMock.start(1), m
    assistant_2 = Assistant.start l, AnsweringMock.start(2), m

    Pupil.make_question pupil, :a_question
    
    assert_receive {_, {:answer, _}}, 1000
    refute_receive {_, {:answer, _}}, 1000
  end
end
