defmodule Rush.Game do
  def play! do
    {:ok, segment1} = GenServer.start_link(Rush.RoadSegment, :segment2, name: :segment1)
    GenServer.start_link(Rush.Tower, [target: segment1])
    GenServer.start_link(Rush.Tower, [target: segment1])


    {:ok, segment2} = GenServer.start_link(Rush.RoadSegment, :segment3, name: :segment2)
    GenServer.start_link(Rush.Tower, [target: segment2])
    GenServer.start_link(Rush.Tower, [target: segment2])

    {:ok, segment3} = GenServer.start_link(Rush.RoadSegment, Rush.End, name: :segment3)
    GenServer.start_link(Rush.Tower, [target: segment3])
    GenServer.start_link(Rush.Tower, [target: segment3])

    {:ok, _end_of_road} = Rush.End.start_link()

    {:ok, _spawner} = GenServer.start_link(Rush.MonsterSpawner, [])

    {:ok, _game_logger} = GenServer.start_link(Rush.GameLogger, [])
  end
end
