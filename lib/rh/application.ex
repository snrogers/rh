defmodule RH.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      RH.Repo,
      # Start the endpoint when the application starts
      RHWeb.Endpoint,
      %{
        id: "scrape_every_5_minutes",
        start: {SchedEx, :run_every, [RH.Scraper, :scrape, [], "*/5 * * * *"]}
      },
      {DynamicSupervisor, name: RH.ScraperSupervisor, strategy: :one_for_one},
      {RH.Watcher, name: RH.Watcher}

      # Starts a worker by calling: RH.Worker.start_link(arg)
      # {RH.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_all, name: RH.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    RHWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
