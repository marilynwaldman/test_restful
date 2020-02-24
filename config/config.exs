# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :test_restful,
  ecto_repos: [TestRestful.Repo]

# Configures the endpoint
config :test_restful, TestRestfulWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3s3uCAa4WDHZExVutyRjrwwHM7yWzHgYNJXCTDO/pC/3gESKFENuOfCtZ0T4wSX8",
  render_errors: [view: TestRestfulWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TestRestful.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "ykjpIzHJXgyxbvITSd6cb7JYPn1UOpPz"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
