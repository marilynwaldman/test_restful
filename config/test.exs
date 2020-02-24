use Mix.Config

# Configure your database
config :test_restful, TestRestful.Repo,
  username: "postgres",
  password: "postgres",
  database: "test_restful_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :test_restful, TestRestfulWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
