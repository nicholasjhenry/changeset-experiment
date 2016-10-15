defmodule Directory.AddressTest do
  use Directory.ModelCase

  alias Directory.Address

  @valid_attrs %{city: "some content", country: "some content", region: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Address.changeset(%Address{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Address.changeset(%Address{}, @invalid_attrs)
    refute changeset.valid?
  end
end
