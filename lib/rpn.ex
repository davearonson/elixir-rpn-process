defmodule Rpn do

  use GenServer

  # CLIENT API

  def start(options \\ []) do
    GenServer.start_link(__MODULE__, [], options)
  end

  def start_link(options \\ []) do
    start(options)
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

  def handle_cast(what, state) do
    result = stack_op(what, state)
    GenServer.cast(Taper, {what, result})
    {:noreply, result}
  end

  defp stack_op(:+, [a,b|t]), do: [b+a|t]
  defp stack_op(:-, [a,b|t]), do: [b-a|t]  # NOTE ORDER!
  defp stack_op(:x, [a,b|t]), do: [b*a|t]
  defp stack_op(:/, [a,b|t]), do: [b/a|t]  # /0?  Let It Crash!
  defp stack_op(nm, state) when is_number(nm), do: [nm|state]

end
