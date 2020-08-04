defmodule Rush.Tower do
  use GenServer

  def init([target: target, dps: dps] = state) do
    send(self(), :shoot)
    {:ok, state}
  end

  def handle_info(:shoot, state) do
    Process.send_after(self(), :shoot, 1_000)
    send(state[:target], {:shoot, state[:dps]})
    {:noreply, state}
  end
end
