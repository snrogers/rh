defmodule RH.Watcher do
  use Supervisor
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(args) do
    {:ok, watcher_pid} =
      FileSystem.start_link(
        dirs: [
          "lib"
        ]
      )

    {:ok, scraper_pid} = DynamicSupervisor.start_child(RH.ScraperSupervisor, RH.Scraper)

    FileSystem.subscribe(watcher_pid)

    {:ok, %{watcher_pid: watcher_pid, scraper_pid: scraper_pid}}
  end

  def handle_info(
        {:file_event, watcher_pid, {paths, events}},
        %{watcher_pid: watcher_pid, scraper_pid: scraper_pid} = state
      ) do
    case events do
      [:modified, :closed] ->
        Logger.debug("--- FILESYSTEM EVENT")
        Logger.debug("Paths: " <> inspect(paths))
        Logger.debug("Events: " <> inspect(events))
        Logger.debug("Paths: " <> inspect(paths))

        Logger.debug("--- ----------------")

        :ok = DynamicSupervisor.terminate_child(RH.ScraperSupervisor, scraper_pid)

        Logger.debug("Recompiling...")
        IEx.Helpers.recompile()

        {:ok, scraper_pid} = DynamicSupervisor.start_child(RH.ScraperSupervisor, RH.Scraper)

        {:noreply, %{watcher_pid: watcher_pid, scraper_pid: scraper_pid}}

      _ ->
        {:noreply, state}
    end
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid = state}) do
    # TODO: Logic when monitoring stops
    {:noreply, state}
  end
end
