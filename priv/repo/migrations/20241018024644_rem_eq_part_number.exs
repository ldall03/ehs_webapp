defmodule EhsWebapp.Repo.Migrations.RemEqPartNumber do
  use Ecto.Migration

  def change do
    alter table(:equipments) do
      remove :part_number
    end
  end
end
