defmodule Rpn do

  # CLIENT SIDE

  def start do
    {:ok, spawn(Rpn, :loop, [[]])}
  end

  def peek(pid) do
    ref = make_ref()
    send(pid, {self, ref, :peek})
    receive do
      {:ok, ^ref, val} -> val
    end
  end

  def push(pid, cmd) when is_number(cmd) or is_atom(cmd) do
    send(pid, cmd)
  end

  # SERVER SIDE

  def loop(state) do
    new_state = receive do
      { peer, nonce, :peek } ->
        send(peer, {:ok, nonce, state})
        state
      :+ -> add(state)
      :- -> sub(state)
      :x -> mul(state)
      num when is_number(num) -> [num|state]
    end
    loop(new_state)
  end

  defp add([op1, op2|t]), do: [op1 + op2|t]
  defp sub([op1, op2|t]), do: [op2 - op1|t]  # NOTE ORDER!
  defp mul([op1, op2|t]), do: [op1 * op2|t]

end
