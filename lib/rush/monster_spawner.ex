defmodule Rush.MonsterSpawner do
  use GenStage

  alias Rush.Monster

  @spawn_rate Application.get_env(:rush, :spawn_rate)
  @spawn_health Application.get_env(:rush, :spawn_health)

  def start_link(_) do
    GenStage.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    send(self(), :spawn)
    {:producer, %{demand: 0, monsters: []}}
  end

  def handle_info(:spawn, state) do
    Process.send_after(self(), :spawn, 2_000)

    new_monsters = List.duplicate(%Monster{health: @spawn_health}, @spawn_rate)
    handle(state, new_monsters, 0)
  end

  def handle_demand(demand, state) do
    handle(state, [], demand)
  end

  defp handle(state, new_monsters, new_demand) do
    all_monsters = state[:monsters] ++ new_monsters
    all_demand = state[:demand] + new_demand
    {demanded_monsters, remaining_monsters} = Enum.split(all_monsters, all_demand)
    new_state = state
    |> Map.put(:monsters, remaining_monsters)
    |> Map.put(:demand, all_demand - Enum.count(demanded_monsters))
    {:noreply, demanded_monsters, new_state}
  end
end
