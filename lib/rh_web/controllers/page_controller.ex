defmodule RHWeb.PageController do
  use RHWeb, :controller
  require Logger
  require Jason
  require URI
  alias RH.{Repo, HealthPoint}
  import Ecto.Query, only: [from: 2]

  def index(conn, params) do
    Logger.debug("PARAMS: " <> inspect(params))
    Logger.debug("CONN: " <> inspect(conn))

    # health_points =
    #   HealthPoint
    #   |> Repo.all()

    health_points =
      Repo.all(HealthPoint, limit: 1)
      # TODO: Define Jason.Encoder protocol
      |> Enum.map(fn hp -> Map.drop(hp, [:__meta__, :__struct__, :titles]) end)
      |> Jason.encode!()
      |> URI.decode()

    render(conn, "index.html",
      health_points: health_points
    )
  end
end
