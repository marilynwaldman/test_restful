defmodule TestRestfulWeb.UserLive.Show do
  use Phoenix.LiveView
  use Phoenix.HTML


  alias TestRestfulWeb.Router.Helpers, as: Routes
  alias Phoenix.LiveView.Socket
  alias TestRestful.Accounts
  alias TestRestfulWeb.UserView

  def render(assigns), do: UserView.render("show.html", assigns)

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    if connected?(socket), do: TestRestful.Accounts.subscribe(id)
    {:noreply, socket |> assign(id: id) |> fetch()}
  end

  defp fetch(%Socket{assigns: %{id: id}} = socket) do
    assign(socket, user: Accounts.get_user!(id))
  end

  def handle_info({Accounts, [:user, :updated], _}, socket) do
    {:noreply, fetch(socket)}
  end

  def handle_info({Accounts, [:user, :deleted], _}, socket) do
    {:stop,
      socket
      |> put_flash(:error, "This user has been deleted from the system")
      |> redirect(to: Routes.live_path(socket, TestRestfulWeb.UserLive.Index))}
  end
end
