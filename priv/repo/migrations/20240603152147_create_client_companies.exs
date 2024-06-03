defmodule EhsWebapp.Repo.Migrations.CreateClientCompanies do
  use Ecto.Migration

  def change do
    create table(:client_companies) do
      add :company_name, :text
      add :contact_email, :text
      add :contact_phone_number, :text
      add :date_joined, :naive_datetime

      timestamps()
    end
  end
end
