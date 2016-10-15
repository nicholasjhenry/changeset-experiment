defmodule Directory.Repo.Migrations.CreateAddress do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :city, :string
      add :region, :string
      add :country, :string
      add :person_id, references(:people, on_delete: :nothing), null: false

      timestamps()
    end
    create index(:addresses, [:person_id])
    create unique_index(:addresses, [:city])

  end
end
