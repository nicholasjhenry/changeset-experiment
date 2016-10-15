defmodule Directory.ServiceTest do
  use Directory.ModelCase

  alias Directory.Person

  test "inserting a person with a duplicate family name"  do
    insert_person_with_duplicate_family_name(":duplicated_family_name:")

    changeset = Person.changeset(%Person{}, %{given_name: ":given_name:", family_name: ":duplicated_family_name:"})

    result = Repo.insert(changeset)
    assert {:error, changeset} = result
    assert {:family_name, "has already been taken"} in errors_for(changeset)
  end

  def insert_person_with_duplicate_family_name(family_name) do
    %Person{given_name: ":another_name:", family_name: ":duplicated_family_name:"}
    |> Repo.insert!
  end
end
