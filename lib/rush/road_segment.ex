defmodule Rush.RoadSegment do
  use GenServer

  alias Rush.Monster

  def init(next_segment) do
    {:ok, %{monsters: [], next_segment: next_segment}}
  end

  def handle_call({:new_monsters, new_monsters}, _from, state) do
    current_monsters = state[:monsters]
    :ok = GenServer.call(state[:next_segment], {:new_monsters, current_monsters})
    new_state = Map.put(state, :monsters, new_monsters)
    {:reply, :ok, new_state}
  end

  def handle_info({:shoot, damage}, %{monsters: monsters} = state) do
    new_monsters = apply_damage(monsters, damage)
    new_state = Map.put(state, :monsters, new_monsters)
    {:noreply, new_state}
  end

  defp apply_damage([], _), do: []
  defp apply_damage([monster | other_monsters], damage) do
    new_health = monster.health - damage
    if new_health <= 0 do
      other_monsters
    else
      [%Monster{monster | health: new_health}] ++ other_monsters
    end
  end
end
