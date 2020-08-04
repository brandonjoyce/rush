defmodule Rush.RoadSegment do
  use GenStage

  alias Rush.Monster

  def init(_) do
    {:producer_consumer, %{}}
  end

  def handle_events(monsters, _from, state) do
    # passthrough
    {:noreply, monsters, state}
  end
end
