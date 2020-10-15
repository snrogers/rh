defmodule RH.HealthPoint do
  use Ecto.Schema
  import Ecto.Changeset
  require Jason

  @derive Jason.Encoder
  schema "health_points" do
    field :mixed, :float
    field :negative, :float
    field :neutral, :float
    field :positive, :float
    field :sentiment, :string
    field :titles, :string

    timestamps()
  end

  @doc false
  def changeset(health_point, attrs) do
    health_point
    |> cast(attrs, [:titles, :sentiment, :mixed, :negative, :neutral, :positive])
    |> validate_required([:titles, :sentiment, :mixed, :negative, :neutral, :positive])
  end
end
