defmodule Rush.GameLogger do
  use GenServer

  @log_rate Application.get_env(:rush, :log_rate_ms)

  def init(_) do
    send(self(), :log)
    {:ok, nil}
  end

  def handle_info(:log, _) do
    [:tower1, :tower2, :tower3, :tower4, :tower5, :tower6]
    |> Enum.map(fn(pid) ->
      %{state: %{monsters: monsters}} = :sys.get_state(pid)
      _total_health = Enum.reduce(monsters, 0, fn(monster, total) -> total + monster.health end)
    end)
    |> build_log()
    |> IO.puts()

    Process.send_after(self(), :log, @log_rate)

    {:noreply, nil}
  end

  defp build_log(towers) do
    [tower1, tower2, tower3, tower4, tower5, tower6] = towers
    "1⃣  ❤#{tower1 + tower2} 2⃣  ❤#{tower3 + tower4} 3⃣  ❤#{tower5 + tower6}"
  end
end
