defmodule Rush.Tower do
  use GenServer

  @dps Application.get_env(:rush, :tower_dps)

  def init([target: _target] = state) do
    new_state = Keyword.put(state, :dps, @dps)
    send(self(), :shoot)
    {:ok, new_state}
  end

  def handle_info(:shoot, state) do
    Process.send_after(self(), :shoot, 1_000)
    send(state[:target], {:shoot, state[:dps]})
    {:noreply, state}
  end
end
