defmodule RH.Repo.Migrations.CreateHealthpoints do
  use Ecto.Migration

  def change do
    create table(:health_points) do
      add :titles, :text
      add :sentiment, :string
      add :mixed, :float
      add :negative, :float
      add :neutral, :float
      add :positive, :float

      timestamps()
    end
  end
end
