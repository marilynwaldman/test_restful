defmodule TestRestfulWeb.PageController do
  use TestRestfulWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
