defmodule TestRestfulWeb.TableLive do
  use Phoenix.LiveView
  #alias TestRestful.Accounts
  #alias TestRestfulWeb.UserView

  def render(assigns) do
    ~L"""
    <form phx-change="search"><input type="text" name="query" value="<%= @query %>" placeholder="Search..." /></form>

    <table>
      <thead>
        <tr>
          <th phx-click="sort" phx-value="name">
            Name <%= sort_order_icon("name", @sort_by, @sort_order) %>
          </th>
          <th phx-click="sort" phx-value="email">
            Population <%= sort_order_icon("email", @sort_by, @sort_order) %>
          </th>
          <th phx-click="sort" phx-value="phone_number">
            Region <%= sort_order_icon("phone_number", @sort_by, @sort_order) %>
          </th>
        </tr>
      </thead>

      <tbody>
        <%= for row <- rows(assigns) do %>
          <tr>
            <td><%= row["name"] %></td>
            <td><%= row["email"] %></td>
            <td><%= row["phone_number"] %></td>
          </tr>
        <% end %>
      </tbody>
    </table>

    <nav class="float-left">
      <%= for page <- (1..number_of_pages(assigns)) do %>
        <%= if page == @page do %>
          <strong><%= page %></strong>
        <% else %>
          <a href="#" phx-click="goto-page" phx-value=<%= page %>><%= page %></a>
        <% end %>
      <% end %>
    </nav>

    <form phx-change="change-page-size" class="float-right">
      <select name="page_size">
        <%= for page_size <- [5, 10, 25, 50] do %>
          <option value="<%= page_size %>" <%= page_size == @page_size && "selected" || "" %>>
            <%= page_size %> per page
           </option>
        <% end %>
      </select>
    </form>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, data: TestRestful.Accounts.list_users(), query: nil, sort_by: "name", sort_order: :desc, page: 1, page_size: 10)}
  end

  def handle_params(params, _url, socket) do
    query = params["query"]
    sort_by =
      case params["sort_by"] do
        sort_by when sort_by in ~w(name email phone_number) ->
          params["sort_by"]
        _ ->
          "name"
      end
    sort_order = params["sort_order"] == "asc" && :asc || :desc
    page = String.to_integer(params["page"] || "1")
    page_size = String.to_integer(params["page_size"] || "10")
    {:noreply, assign(socket, query: query, sort_by: sort_by, sort_order: sort_order, page: page, page_size: page_size)}
  end

  def handle_event("search", %{"query" => query}, socket) do
    {:noreply, redirect_with_attrs(socket, query: query, page: 1)}
  end

  # When the column that is used for sorting is clicked again, we reverse the sort order
  def handle_event("sort", column, %{assigns: %{sort_by: sort_by, sort_order: :asc}} = socket) when column == sort_by do
    {:noreply, assign(socket, sort_by: sort_by, sort_order: :desc)}
  end
  def handle_event("sort", column, %{assigns: %{sort_by: sort_by, sort_order: :desc}} = socket) when column == sort_by do
    {:noreply, redirect_with_attrs(socket, sort_by: sort_by, sort_order: :asc)}
  end

  # A new column has been clicked
  def handle_event("sort", column, socket) do
    {:noreply, redirect_with_attrs(socket, sort_by: column)}
  end

  def handle_event("goto-page", page, socket) do
    {:noreply, redirect_with_attrs(socket, page: String.to_integer(page))}
  end

  def handle_event("change-page-size", %{"page_size" => page_size}, socket) do
    {:noreply, redirect_with_attrs(socket, page_size: String.to_integer(page_size), page: 1)}
  end

  defp redirect_with_attrs(socket, attrs) do
    query = attrs[:query] || socket.assigns[:query]
    sort_by = attrs[:sort_by] || socket.assigns[:sort_by]
    sort_order = attrs[:sort_order] || socket.assigns[:sort_order]
    page = attrs[:page] || socket.assigns[:page]
    page_size = attrs[:page_size] || socket.assigns[:page_size]

    live_redirect(socket, to: TestRestfulWeb.Router.Helpers.live_path(socket, __MODULE__, query: query, sort_by: sort_by, sort_order: sort_order, page: page, page_size: page_size))
  end

  defp rows(%{data: data, query: query, sort_by: sort_by, sort_order: sort_order, page: page, page_size: page_size}) do
    data |> filter(query) |> sort(sort_by, sort_order) |> paginate(page, page_size)
  end

  defp filter(rows, query) do
    rows |> Enum.filter(&(String.match?(&1["name"], ~r/#{query}/i)))
  end

  defp sort(rows, sort_by, :asc), do: rows |> Enum.sort(&(&1[sort_by] > &2[sort_by]))
  defp sort(rows, sort_by, :desc), do: rows |> Enum.sort(&(&1[sort_by] <= &2[sort_by]))

  defp paginate(rows, page, page_size), do: rows |> Enum.slice((page - 1) * page_size, page_size)


  defp number_of_pages(%{data: data, query: query, page_size: page_size}) do
    number_of_rows = data |> filter(query) |> length
    (number_of_rows / page_size) + 1 |> trunc
  end

  defp sort_order_icon(column, sort_by, :asc) when column == sort_by, do: "▲"
  defp sort_order_icon(column, sort_by, :desc) when column == sort_by, do: "▼"
  defp sort_order_icon(_, _, _), do: ""
end
