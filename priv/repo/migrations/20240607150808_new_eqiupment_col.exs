defmodule EhsWebapp.Repo.Migrations.NewEqiupmentCol do
  use Ecto.Migration

  def change do
    alter table("equipments") do
      add :equipment, :string
    end
  end
end
