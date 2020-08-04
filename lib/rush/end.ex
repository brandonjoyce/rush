defmodule Rush.End do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_call({:new_monsters, new_monsters}, _from, _) do
    new_monsters
    |> Enum.each(fn(monster) ->
      IO.puts "🔥👹 health: #{monster.health} reached our flag🔥"
    end)
    {:reply, :ok, nil}
  end
end
