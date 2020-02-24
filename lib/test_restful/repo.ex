defmodule TestRestful.Repo do
  use Ecto.Repo,
    otp_app: :test_restful,
    adapter: Ecto.Adapters.Postgres
end
