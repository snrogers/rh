defmodule RH.Reddit do
  use Tesla

  adapter(Tesla.Adapter.Hackney)

  plug Tesla.Middleware.BaseUrl, "https://old.reddit.com"

  def front_page do
    get("")
  end
end
