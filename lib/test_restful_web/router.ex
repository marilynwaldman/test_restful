defmodule TestRestfulWeb.Router do
  use TestRestfulWeb, :router

  #pipeline :browser do
  #plug :accepts, ["html"]
  #  plug :fetch_session
    #plug :fetch_live_flash
    #plug :protect_from_forgery
    #plug :put_secure_browser_headers
  #end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TestRestfulWeb do
    pipe_through :browser
    live "/", UserLive.Index
    live "/users", UserLive.Index
    live "/users/new", UserLive.New
    live "/users/:id", UserLive.Show
    live "/users/:id/edit", UserLive.Edit
    #get "/", PageController, :index
    #resources "/users", UserController

  end

  # Other scopes may use custom stacks.
  # scope "/api", TestRestfulWeb do
  #   pipe_through :api
  # end
end
