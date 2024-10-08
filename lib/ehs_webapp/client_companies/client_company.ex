defmodule EhsWebapp.ClientCompanies.ClientCompany do
  use Ecto.Schema
  import Ecto.Changeset

  schema "client_companies" do
    field :company_name, :string
    field :contact_email, :string
    field :contact_phone_number, :string
    field :date_joined, :date
    has_many :equipment_ownerships, EhsWebapp.EquipmentOwnerships.EquipmentOwnership
    has_many :users, EhsWebapp.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(client_company, attrs) do
    client_company
    |> cast(attrs, [:company_name, :contact_email, :contact_phone_number, :date_joined])
    |> validate_required([:company_name])
  end
end
