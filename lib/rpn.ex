defmodule Rpn do

  use GenServer

  # CLIENT API

  def start do
    GenServer.start_link(__MODULE__, [], [])
  end

  def peek(server) do
    ref = make_ref()
    {^ref, val} = GenServer.call(server, {ref, :peek})
    val
  end

  def push(server, cmd) when is_number(cmd) or is_atom(cmd) do
    GenServer.cast(server, cmd)
  end

  # SERVER API

  def init(state) do
    {:ok, state}
  end

  def handle_call({nonce, :peek}, _from, state) do
    {:reply, {nonce, state}, state}
  end

  def handle_cast(:+, [a,b|t]), do: {:noreply, [b+a|t]}
  def handle_cast(:-, [a,b|t]), do: {:noreply, [b-a|t]}  # NOTE ORDER!
  def handle_cast(:x, [a,b|t]), do: {:noreply, [b*a|t]}
  def handle_cast(nm, state) when is_number(nm) do
    {:noreply, [nm|state]}
  end

end
