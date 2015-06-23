import EtsStore

defmodule EtsServer do
  use GenServer

  @doc "stating up the server"
  def start_link do
    GenServer.start_link(__MODULE__, [], [{:name, __MODULE__}])
  end

  @doc "stopping the server"
  def stop() do
    GenServer.cast(:NAME, :stop)
  end

  @doc "handle cast is only a async call that can be received or not by the gen server. In this case the server should always avoid returning anything. In this case we are using create_table for didactic purposes"
  def handle_cast({:create_table, table_name}, state) do
    EtsStore.new_table(table_name)
    {:noreply, state}
  end

  def handle_call({:is_table_defined, table_name}, _from, state) do
    case EtsStore.is_table_defined(table_name) do
      {:error, :none_found} -> {:reply, {:error, :none_found}, state}
      {_, x} ->   {:reply, x, state}
    end
  end

  def handle_call({:put, table, name, value}, _from,  state) do
    {:reply, EtsStore.put(table, name, value), state}
  end

  def handle_call({:get, table, name}, _from,  state) do
    case EtsStore.get(table, name) do
      {:error, _} -> {:reply, {:error, :failed_get_ets}, state}
      {:ok, value} -> {:reply, value, state}
      {_ , _} -> {:reply, {:error, :unexpectedError}, state}
    end
  end

  def handle_call({:update, table, name, value}, _from, state) do
    case EtsStore.update(table,name,value) do
      {:error, :not_found} -> {:reply, :failed_update_ets, state}
      {:ok, _} -> {:reply, :succesful_update, state}
    end
  end

  def handle_cast({:delete, table, name}, state) do
    EtsStore.delete(table, name)
    {:noreply, state}
  end

end
