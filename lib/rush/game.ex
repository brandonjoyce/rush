defmodule Rush.Game do
  def play! do
    {:ok, spawner} = GenStage.start_link(Rush.MonsterSpawner, [])
    {:ok, segment1} = GenStage.start_link(Rush.RoadSegment, nil, name: :segment1)
    {:ok, segment2} = GenStage.start_link(Rush.RoadSegment, nil, name: :segment2)
    {:ok, segment3} = GenStage.start_link(Rush.RoadSegment, nil, name: :segment3)
    {:ok, tower1} = GenStage.start_link(Rush.Tower, [], name: :tower1)
    {:ok, tower2} = GenStage.start_link(Rush.Tower, [], name: :tower2)
    {:ok, tower3} = GenStage.start_link(Rush.Tower, [], name: :tower3)
    {:ok, tower4} = GenStage.start_link(Rush.Tower, [], name: :tower4)
    {:ok, tower5} = GenStage.start_link(Rush.Tower, [], name: :tower5)
    {:ok, tower6} = GenStage.start_link(Rush.Tower, [], name: :tower6)

    {:ok, _end_of_road} = Rush.End.start_link()

    {:ok, _game_logger} = GenServer.start_link(Rush.GameLogger, [])

    {:ok, _} = GenStage.sync_subscribe(segment1, to: spawner, max_demand: 10, min_demand: 4)
    {:ok, _} = GenStage.sync_subscribe(segment2, to: spawner, max_demand: 10, min_demand: 4)
    {:ok, _} = GenStage.sync_subscribe(segment3, to: spawner, max_demand: 10, min_demand: 4)
    {:ok, _} = GenStage.sync_subscribe(tower1, to: segment1)
    {:ok, _} = GenStage.sync_subscribe(tower2, to: segment1)
    {:ok, _} = GenStage.sync_subscribe(tower3, to: segment2)
    {:ok, _} = GenStage.sync_subscribe(tower4, to: segment2)
    {:ok, _} = GenStage.sync_subscribe(tower5, to: segment3)
    {:ok, _} = GenStage.sync_subscribe(tower6, to: segment3)
  end
end
