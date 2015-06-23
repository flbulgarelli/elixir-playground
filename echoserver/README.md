Echoserver
==========

This is an example for an Echo server using the gen_tcp which enables operation with TCP sockets in Elixir.

The flow of the server es pretty straightforward as it's only a OTP process that listens to a port, and accepts connections to it.
and on the dispatch it'll only read the content of the packet and send it back.

For starting we need to start listening to a designed port

```elixir
  tcp_options = [:binary, {:packet, 0}, {:active, false}, {:reuseaddr, true}]
  {:ok, socket} = :gen_tcp.listen(port, tcp_options)
```

The options mean the following:

1. :binary - receives data as binaries (instead of lists)
2. packet: :line - receives data line by line
3. active: false - blocks on :gen_tcp.recv/2 until data is available
4. reuseaddr: true - allows us to reuse the address if the listener crashes

Continuing with this, we need to accept all the time incoming packets from the client, to do this we have a loop_acceptor function, that will be used recursively and once it receives a packet from a socket we can serve it.

```elixir
  {:ok, client} = :gen_tcp.accept(socket)
  serve(client)
  loop_acceptor(socket)
```

Serving the packet implies only reading and writing back the contetnts of the packet. to do this we implement the serve function that has the following body

```
  socket
  |> read_line()
  |> write_line(socket)
```
This function implements the pipeline operator |. The pipeline evaluates the left side and passes its result as first argument to the function on the right side.


## Running the example

You'll need mix to run the example. To execute the example only enter the following commands:

```
 iex -S mix
```

and in the elixir console

```
  Interactive Elixir (1.0.4) - press Ctrl+C to exit (type h() ENTER for help)
  iex(1)> EchoServer.start(1050)
```

After this only do a telnet to 127.0.0.1 1050 and write anything once you have

## Introducing Tasks

If you wan to automatize the server you can use an Elixir task. A task is used to run and do nothing further. This is different that happens with other OTP objects like agents, generic servers or event managers, that in opposite tend to work with multiple messages or handle and manage an internal state.

```elixir
  def run(port \\ 1050) do
    Echo.Server.start(port)
  end
```  
This snipplet show how does the run command is implemented for a task, after this the way to run the task from console is only by doing something like:

```
  mix do compile, start
```

## Limitations of the first version

Even thought erlang/elixir are languages that are designed for concurrency or paralelism, this first example shows that only one client can connect at a time to the echo server, as for example, if we connect to a second user into the echo server it'll accept the connection but won't serve him. Tjis is because we are serving requests in the same process that are accepting connections.

## Supervisor version

For this version we want to have multiple process to handle the requests and the connections, so in this case we introduce the
supervisors. Supervisors exists to spawn new process, manage them and once they're finished, kill them. This is particulary simple to have multiple process and you want to handle them in a simple way. Also it helps you to finish unsupervised processes in a clean way without having memory leaks in the long term if you forgot to kill a process that has been finished long ago.

The supervisors have several strategies, which are described [here](http://learnyousomeerlang.com/supervisors)

For this case we're using the one-for-one strategy, in which our supervisor, if he finds that one of the process has failed, it'll restart that only process and won't interrupt the status of the rest of them, this is useful in this case where we have independent processes that have no correlation one with each other.

![Supervisor one-for-one strategy](http://learnyousomeerlang.com/static/img/restart-one-for-one.png)

To run it execute:

```
 iex -S mix
```

and in the elixir console

```
Interactive Elixir (1.0.4) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> EchoSupervisor.start(EchoServer, 2030)

```

## Further example

Another interesting example could be an Echo server with a supervisor process. See [this link](http://elixir-lang.org/getting-started/mix-otp/task-and-gen-tcp.html) for more information.
