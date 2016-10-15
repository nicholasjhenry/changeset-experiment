defmodule Directory.ServiceTest do
  use Directory.ModelCase

  alias Directory.{Person}

  # Conclusion: Only valid changesets are attempted to be inserted into the
  # Repo, where they might be invalidated because of database constraints.
  # If there is a parent in the graph that is invalid, further inserts of
  # the graph is holted.

  test "inserting a person with a duplicate family name and missing required attribute and duplicated city on address"  do
    insert_person_with_family_name(":duplicated_family_name:")
    |> insert_address_with_city(":duplicated_city_name:")

    changeset = Person.changeset(
      %Person{},
      %{
        given_name: ":given_name:",
        family_name: ":duplicated_family_name:",
        addresses: [
          %{
            city: ":duplicated_city_name:",
            country: "Canada"
          }
        ]
      }
    )

    result = Repo.insert(changeset)
    assert {:error, changeset} = result

    # Since the child has an error on it, the parent unique constraint is not
    # validated or the child unique constraint
    assert {:addresses, %{region: ["can't be blank"]}} in errors_for(changeset)
    refute {:addresses, %{city: ["has already been taken"]}} in errors_for(changeset)
    refute {:family_name, "has already been taken"} in errors_for(changeset)
  end

  test "inserting a person with a duplidate family name on person and a duplicate city name on address"  do
    insert_person_with_family_name(":duplicated_family_name:")
    |> insert_address_with_city(":duplicated_city_name:")

    changeset = Person.changeset(
      %Person{},
      %{
        given_name: ":given_name:",
        family_name: ":duplicated_family_name:",
        addresses: [
          %{
            city: ":duplicated_city_name:",
            region: "Quebec",
            country: "Canada"
          }
        ]
      }
    )

    result = Repo.insert(changeset)
    assert {:error, changeset} = result

    # Since the parent has a unqiue constraint error on it, the child unique constraint is not
    # validated.
    refute {:addresses, %{city: ["has already been taken"]}} in errors_for(changeset)
    assert {:family_name, "has already been taken"} in errors_for(changeset)
  end

  test "updating a person with a duplidate family name on person and a duplicate city name on address"  do
    insert_person_with_family_name(":duplicated_family_name:")
    |> insert_address_with_city(":duplicated_city_name:")

    existing_person = insert_person_with_family_name(":existing_family_name:") |> Repo.preload(:addresses)
    existing_address = insert_address_with_city(existing_person, ":existing_city_name:")

    changeset = Person.changeset(
      existing_person,
      %{
        family_name: ":duplicated_family_name:",
        addresses: [
          %{
            id: existing_address.id,
            city: ":duplicated_city_name:",
            region: "Quebec",
            country: "Canada"
          }
        ]
      }
    )

    result = Repo.update(changeset)
    assert {:error, changeset} = result

    # Since the parent has a unqiue constraint error on it, the child unique constraint is not
    # validated.
    refute {:addresses, %{city: ["has already been taken"]}} in errors_for(changeset)
    assert {:family_name, "has already been taken"} in errors_for(changeset)
  end

  def insert_person_with_family_name(family_name) do
    %Person{given_name: ":another_name:", family_name: family_name}
    |> Repo.insert!
  end

  def insert_address_with_city(person, city) do
    build_assoc(person, :addresses, %{city: city, region: "Quebec", country: "Canada"})
    |> Repo.insert!
  end
end
