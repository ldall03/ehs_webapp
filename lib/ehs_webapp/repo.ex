defmodule EhsWebapp.Repo do
  use Ecto.Repo,
    otp_app: :ehs_webapp,
    adapter: Ecto.Adapters.Postgres
end
