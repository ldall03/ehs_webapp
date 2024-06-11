defmodule EhsWebappWeb.AdminPanelLive.ClientsComponent do
  use EhsWebappWeb, :live_component

  alias EhsWebapp.{ClientCompanies, ClientCompanies.ClientCompany}

  def mount(socket) do
    socket = assign(socket,
      form: to_form(ClientCompanies.change_client_company(%ClientCompany{}))
    )
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="bg-ccLight w-5/6">
      <div class="font-bold p-8 text-xl">Clients</div>
      <.form for={@form} phx-submit="new_client" phx-target={@myself}>
        <.input type="text" label="Company Name*" name="company_name" placeholder="Company Name" value="" autocomplete="off" field={@form[:company_name]}/>
        <.input type="email" label="Contact Email" name="contact_email" placeholder="Contact Email" value="" autocomplete="off" field={@form[:contact_email]}/>
        <.input type="text" label="Phone Number" name="contact_phone_number" placeholder="Phone Number" value="" autocomplete="off" field={@form[:contact_phone_number]}/>
        <.input type="date" label="Date Joined" name="date_joined"  value="" autocomplete="off" field={@form[:date_joined]}/>
        <.button type="submit">Add Client</.button>
      </.form>
    </div>
    """
  end

  def handle_event("new_client", params, socket) do # TODO[con]: reset form
    ClientCompanies.create_client_company(params)
    {:noreply, socket}
  end
end
