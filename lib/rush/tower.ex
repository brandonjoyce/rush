defmodule Rush.Tower do
  use GenStage

  alias Rush.Monster

  @dps Application.get_env(:rush, :tower_dps)
  @monster_demand 3

  def init(state) do
    send(self(), :shoot)
    state = %{dps: @dps, monsters: [], segment: nil, pending_demand: 0}
    {:consumer, state}
  end

  def handle_info(:shoot, state) do
    Process.send_after(self(), :shoot, 1_000)
    new_state = state
                |> apply_damage()
                |> demand_monsters()
    {:noreply, [], new_state}
  end

  def handle_events(monsters, _from, state) do
    new_pending_demand = state[:pending_demand] - Enum.count(monsters)
    new_monsters = state[:monsters] ++ monsters
    new_state = state
                |> Map.put(:monsters, new_monsters)
                |> Map.put(:pending_demand, new_pending_demand)
    {:noreply, [], new_state}
  end

  def handle_subscribe(:producer, opts, from, state) do
    new_state = state
            |> Map.put(:segment, from)
            |> demand_monsters()
    {:manual, new_state}
  end

  defp demand_monsters(%{segment: nil} = state), do: state
  defp demand_monsters(state) do
    required_demand = @monster_demand - (Enum.count(state[:monsters]) + state[:pending_demand])
    if required_demand > 0 do
      GenStage.ask(state[:segment], required_demand)
      Map.put(state, :pending_demand, state[:pending_demand] + required_demand)
    else
      state
    end
  end

  defp apply_damage(%{monsters: []} = state), do: state
  defp apply_damage(%{monsters: [monster | other_monsters]} = state) do
    new_health = monster.health - @dps
    damaged_monsters = if new_health <= 0 do
      other_monsters
    else
      [%Monster{monster | health: new_health}] ++ other_monsters
    end
    Map.put(state, :monsters, damaged_monsters)
  end
end
