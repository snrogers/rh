defmodule RH.Scraper do
  require Logger
  require Floki
  alias RH.{Repo, HealthPoint}

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

  def scrape do
    Logger.debug("Fetching titles...")
    titles = get_titles() |> Enum.join("\n")

    Logger.debug("Computing sentiment...")
    {sentiment, sentiments} = RH.AWS.comprehend(titles)

    Logger.debug("Saving sentiment...")
    # TODO: Is there a cleaner syntax for this?
    Repo.insert(%HealthPoint{
      titles: titles,
      sentiment: sentiment,
      mixed: sentiments["Mixed"],
      negative: sentiments["Negative"],
      neutral: sentiments["Neutral"],
      positive: sentiments["Positive"]
    })

    Logger.debug("Sentiments:\n" <> inspect(sentiments))
  end
end
