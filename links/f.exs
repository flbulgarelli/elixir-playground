defmodule F do
  def loop(f) do
    l = fn l ->
     f.()
     l.(l)
    end
    l.(l)
  end

  def loopf(f) do
    fn -> loop f end
  end
end

