defmodule Rush.Game do
  def play! do
    {:ok, segment1} = GenServer.start_link(Rush.RoadSegment, :segment2, name: :segment1)
    GenServer.start_link(Rush.Tower, [target: segment1, dps: 40])
    GenServer.start_link(Rush.Tower, [target: segment1, dps: 40])


    {:ok, segment2} = GenServer.start_link(Rush.RoadSegment, :segment3, name: :segment2)
    GenServer.start_link(Rush.Tower, [target: segment2, dps: 40])
    GenServer.start_link(Rush.Tower, [target: segment2, dps: 40])

    {:ok, segment3} = GenServer.start_link(Rush.RoadSegment, Rush.End, name: :segment3)
    GenServer.start_link(Rush.Tower, [target: segment3, dps: 40])
    GenServer.start_link(Rush.Tower, [target: segment3, dps: 40])

    {:ok, end_of_road} = Rush.End.start_link()

    {:ok, spawner} = GenServer.start_link(Rush.MonsterSpawner, [])
  end
end
