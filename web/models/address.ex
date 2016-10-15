defmodule Directory.Address do
  use Directory.Web, :model

  schema "addresses" do
    field :city, :string
    field :region, :string
    field :country, :string
    belongs_to :person, Directory.Person

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:city, :region, :country])
    |> validate_required([:city, :region, :country])
    |> unique_constraint(:city)
  end
end
