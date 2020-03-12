defmodule RHWeb.PageController do
  use RHWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
