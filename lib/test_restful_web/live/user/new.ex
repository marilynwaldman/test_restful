defmodule TestRestfulWeb.UserLive.New do
  require Logger
  use Phoenix.LiveView

  alias TestRestfulWeb.{UserLive,UserView}
  alias TestRestfulWeb.Router.Helpers, as: Routes
  alias TestRestful.Accounts
  alias Accounts.User

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user(%User{})
    {:ok, assign(socket, changeset: changeset)}
  end

  def render(assigns), do: Phoenix.View.render(TestRestfulWeb.UserView, "new.html", assigns)

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      %User{}
      |> TestRestful.Accounts.change_user(user_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case TestRestful.Accounts.create_user(user_params) do
      {:ok, user} ->
        {:noreply,
          socket
          |> put_flash(:info, "user created")
          |> redirect(to: Routes.live_path(socket, UserLive.Show, user))}

      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.info  "save not ok"
        {:noreply, assign(socket, changeset: changeset)}
    end
  end


end
