defmodule Directory.Repo.Migrations.CreatePerson do
  use Ecto.Migration

  def change do
    create table(:people) do
      add :given_name, :string
      add :family_name, :string

      timestamps()
    end

    create unique_index(:people, [:family_name])
  end
end
