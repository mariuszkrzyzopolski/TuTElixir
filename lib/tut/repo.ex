defmodule Tut.Repo do
  use Ecto.Repo,
    otp_app: :tut,
    adapter: Ecto.Adapters.Postgres
end
