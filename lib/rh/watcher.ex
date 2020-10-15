defmodule RH.Watcher do
  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(_args) do
    {:ok, watcher_pid} =
      FileSystem.start_link(
        dirs: [
          "lib/rh"
        ]
      )

    FileSystem.subscribe(watcher_pid)

    {:ok, %{watcher_pid: watcher_pid}}
  end

  def handle_info(
        {:file_event, watcher_pid, {paths, events}},
        %{watcher_pid: watcher_pid} = state
      ) do
    case events do
      [:modified, :closed] ->
        Logger.debug("--- FILESYSTEM EVENT")
        Logger.debug("Paths: " <> inspect(paths))
        Logger.debug("Events: " <> inspect(events))
        Logger.debug("Paths: " <> inspect(paths))

        Logger.debug("--- ----------------")

        Logger.debug("Recompiling...")
        IEx.Helpers.recompile()

        Logger.debug("Crashing this app...")
        throw("Crash due to change")

        {:noreply, %{watcher_pid: watcher_pid}}

      _ ->
        {:noreply, state}
    end
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid = state}) do
    # TODO: Logic when monitoring stops
    {:noreply, state}
  end
end
