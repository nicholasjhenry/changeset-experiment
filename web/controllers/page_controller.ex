defmodule Directory.PageController do
  use Directory.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
