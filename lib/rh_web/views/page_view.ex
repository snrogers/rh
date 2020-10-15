defmodule RHWeb.PageView do
  use RHWeb, :view
  require URI

  def health_points do
    %{fart: "womp"}
  end
end
