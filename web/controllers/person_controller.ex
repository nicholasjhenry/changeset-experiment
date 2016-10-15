defmodule Directory.PersonController do
  use Directory.Web, :controller

  alias Directory.{Person, Address}
  alias Ecto.Multi

  def index(conn, _params) do
    people =
      Person
      |> Repo.all
      |> Repo.preload(:addresses)
    render(conn, "index.html", people: people)
  end

  def new(conn, _params) do
    person_changeset = Person.changeset(%Person{})
    address_changeset = Address.changeset(%Address{})
    render(conn, "new.html", person_changeset: person_changeset, address_changeset: address_changeset)
  end

  def create(conn, %{"person" => person_params, "address" => address_params}) do
    person_changeset = Person.changeset(%Person{}, person_params)
    address_changeset = Address.changeset(%Address{}, address_params)

    multi =
      Multi.new
      |> Multi.insert(:person, person_changeset)
      |> Multi.merge(fn(%{person: person}) ->
           address_changeset = Ecto.Changeset.put_assoc(address_changeset, :person, person)
           Multi.insert(Multi.new, :address, address_changeset)
         end)

    case Repo.transaction(multi) do
      {:ok, _} ->
        conn
        |> redirect(to: person_path(conn, :index))

      {:error, :person, person_changeset, _changes_so_far} ->
        address_changeset = Map.put(address_changeset, :action, "executed")
        render(conn, "new.html", person_changeset: person_changeset, address_changeset: address_changeset)

      {:error, :address, address_changeset, _changes_so_far} ->
        render(conn, "new.html", person_changeset: person_changeset, address_changeset: address_changeset)
    end
  end
end
