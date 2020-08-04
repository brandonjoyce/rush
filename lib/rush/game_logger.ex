defmodule Rush.GameLogger do
  use GenServer

  @log_rate Application.get_env(:rush, :log_rate_ms)

  def init(_) do
    send(self(), :log)
    {:ok, nil}
  end

  def handle_info(:log, _) do
    [:segment1, :segment2, :segment3]
    |> Enum.map(fn(pid) ->
      %{monsters: monsters} = :sys.get_state(pid)
      _total_health = Enum.reduce(monsters, 0, fn(monster, total) -> total + monster.health end)
    end)
    |> build_log()
    |> IO.puts()

    Process.send_after(self(), :log, @log_rate)

    {:noreply, nil}
  end

  defp build_log(segments) do
    [one, two, three] = segments
    "1⃣  ❤#{one} 2⃣  ❤#{two} 3⃣  ❤#{three}"
  end
end
