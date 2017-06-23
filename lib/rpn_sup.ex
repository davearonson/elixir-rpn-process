defmodule Rpn.Supervisor do
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [
      worker(Rpn, [[name: Calcy]])
    ]
    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end
