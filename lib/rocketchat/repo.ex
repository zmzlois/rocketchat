defmodule Rocketchat.Repo do
  use Ecto.Repo,
    otp_app: :rocketchat,
    adapter: Ecto.Adapters.Postgres
end
