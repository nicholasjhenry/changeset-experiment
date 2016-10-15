defmodule Directory.PersonControllerTest do
  use Directory.ConnCase

  alias Directory.Person

  describe "GET /people/new" do
    test "renders successfully", %{conn: conn} do
      conn = get conn, person_path(conn, :new)
      assert html_response(conn, 200) =~ "New person"
    end
  end

  describe "POST /people" do
    test "with valid attributes", %{conn: conn} do
      conn = post conn, person_path(conn, :create),
        person: %{given_name: ":given_name:", family_name: ":family_name:"},
        address: %{city: ":city:", region: ":region:", country: ":country:"}

      person = Repo.get_by(Person, family_name: ":family_name:")
      assert person
      assert redirected_to(conn) == person_path(conn, :index)
    end

    test "with invalid attributes", %{conn: conn} do
      conn = post conn, person_path(conn, :create),
        person: %{family_name: ":family_name:"},
        address: %{region: ":region:", country: ":country:"}

      assert html_response(conn, 200) =~ "New person"
    end
  end
end
