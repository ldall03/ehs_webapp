defmodule EhsWebapp.Repo.Migrations.StatusCol do
  use Ecto.Migration

  def change do
    alter table("equipment_ownerships") do
      add :status, :string
      add :comments, :string
    end
  end
end
