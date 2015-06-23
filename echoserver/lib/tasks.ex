defmodule Mix.Tasks.Start do
  use Mix.Task

  def start(port) do
    EchoServer.start(port)
  end

end
