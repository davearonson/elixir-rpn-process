defmodule Rpn.TapePrinter do

  use GenServer

  # CLIENT API

  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, [], options)
  end

  # SERVER API

  def init(state) do
    {:ok, state}
  end

  def handle_cast({what, calc_state}, tape_state) do
    IO.puts "Got #{what}; calculator stack now #{inspect calc_state}"
    {:noreply, tape_state}
  end

end
