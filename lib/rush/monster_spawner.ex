defmodule Rush.MonsterSpawner do
  use GenServer

  alias Rush.Monster

  @spawn_rate Application.get_env(:rush, :spawn_rate)
  @spawn_health Application.get_env(:rush, :spawn_health)

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    send(self(), :spawn)
    {:ok, nil}
  end

  def handle_info(:spawn, _) do
    new_monsters = List.duplicate(%Monster{health: @spawn_health}, @spawn_rate)

    :ok = GenServer.call(:segment1, {:new_monsters, new_monsters})

    Process.send_after(self(), :spawn, 2_000)
    {:noreply, nil}
  end
end
