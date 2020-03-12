defmodule RH.Scraper do
  use Task
  require Logger
  require Floki

  def start_link(opts) do
    IO.write(to_string(opts))
    Task.start_link(&poll/0)
  end

  def poll() do
    receive do
    after
      0 ->
        titles =
          get_titles()
          |> Enum.join("\n")

        Logger.debug("TITLES:\n " <> titles)

        RH.AWS.comprehend(titles)

        poll(:delay)
    end
  end

  def poll(:delay) do
    receive do
    after
      300_000 ->
        get_titles()
        |> Enum.join("\n")
        |> (&Logger.debug("TITLES:\n " <> &1)).()

        poll(:delay)
    end
  end

  def get_titles do
    result =
      case RH.Reddit.front_page() do
        {:ok, response} ->
          response
          |> Map.get(:body)
          |> Floki.parse_document()
          |> case do
            {:ok, dom} -> dom
          end
          |> Floki.find("a.title")
          |> Enum.flat_map(&elem(&1, 2))
          |> Enum.map(&String.replace(&1, ~r/^\[SPOILER\] /, ""))

        {:error, reason} ->
          Logger.debug("ERROR:\n" <> inspect(reason))
      end

    result
  end
end
