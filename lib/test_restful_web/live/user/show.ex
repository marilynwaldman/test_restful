defmodule TestRestfulWeb.UserLive.Show
  do
  use Phoenix.LiveView
  use Phoenix.HTML


  alias TestRestfulWeb.Router.Helpers, as: Routes
  alias Phoenix.LiveView.Socket
  alias TestRestful.Accounts
  alias TestRestfulWeb.UserView

  def render(assigns), do: UserView.render("show.html", assigns)

  def mount(_params, _session, socket) do
    {:ok, assign(socket, count: 0)}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    user = Accounts.get_user!(id)
    {:noreply,
      assign(socket, %{
        user: user
      })}
  end

end
