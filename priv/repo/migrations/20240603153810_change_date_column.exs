defmodule EhsWebapp.Repo.Migrations.ChangeDateColumn do
  use Ecto.Migration

  def change do
    alter table(:client_companies) do
      modify :date_joined, :date
    end
  end
end
