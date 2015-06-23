defmodule EchoServer do

  def start(port \\ 1050) do
    #Options
    # 1. `:binary` - receives data as binaries (instead of lists)
    # 2. `packet: :line` - receives data line by line
    # 3. `active: false` - blocks on `:gen_tcp.recv/2` until data is available
    # 4. `reuseaddr: true` - allows us to reuse the address if the listener crashes
    tcp_options = [:binary, {:packet, 0}, {:active, false}, {:reuseaddr, true}]
    {:ok, socket} = :gen_tcp.listen(port, tcp_options)
    IO.puts "Accepting connections on port #{port}"
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    serve(client)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    socket
    |> read_line()
    |> write_line(socket)

    serve(socket)
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    IO.puts "Received raw_data #{data}"
    data
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
