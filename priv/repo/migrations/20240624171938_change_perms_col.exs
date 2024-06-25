defmodule EhsWebapp.Repo.Migrations.ChangePermsCol do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE users ALTER COLUMN permissions TYPE boolean USING permissions::boolean"

    rename table(:users), :permissions, to: :superuser
  end
end
