defmodule EhsWebappWeb.AdminPanelLive.ClientsComponent do
  use EhsWebappWeb, :live_component

  alias EhsWebapp.{ClientCompanies, ClientCompanies.ClientCompany}

  def mount(socket) do
    {:ok, socket
      |> assign(
        form: to_form(ClientCompanies.change_client_company(%ClientCompany{})),
        selection: %ClientCompany{})
      |> stream(:clients, 
        ClientCompanies.list_client_companies() |> Enum.map(fn i -> 
          %{id: i.id, 
            company_name: i.company_name, 
            contact_email: i.contact_email, 
            contact_phone_number: i.contact_phone_number, 
            date_joined: i.date_joined, 
            selected: false}
        end)
      )
    }
  end

  def render(assigns) do
    ~H"""
    <div class="bg-ccLight w-5/6">
      <div class="font-bold p-5 text-xl">Clients</div>
      <div class="bg-white m-5 py-5 rounded-lg border-ccGrey">
        <div class="flex justify-between py-4">
          <p class="w-full text-center font-bold">Name</p>
          <p class="w-full text-center font-bold">Contact Email</p>
          <p class="w-full text-center font-bold">Phone Number</p>
          <p class="w-full text-center font-bold">Date Joined</p>
        </div>
        <div id="clients" phx-update="stream" class="h-96 overflow-scroll">
          <%= for {dom_id, client} <- @streams.clients do %>
            <div class={["flex justify-between py-3 m-1 rounded select-none", client.selected && "bg-ccBlue text-white"]} phx-value-id={client.id} phx-click="select" phx-target={@myself} id={dom_id}>
              <p class="w-full text-center cursor-default"><%= client.company_name %></p>
              <p class="w-full text-center cursor-default"><%= client.contact_email %></p>
              <p class="w-full text-center cursor-default"><%= client.contact_phone_number %></p>
              <p class="w-full text-center cursor-default"><%= client.date_joined %></p>
            </div>
          <% end %>
        </div>
        <div :if={@current_user.superuser} class="text-right">
          <.button phx-click="delete_client" phx-target={@myself} data-confirm="Are you sure you want to delete the client This is irreversible." class="mx-5 mt-5 bg-ccRed hover:bg-ccRed-dark disabled:bg-ccGrey disabled:hover:bg-ccGrey disabled:active:text-white" disabled={!@selection.id}>Delete Client</.button>
        </div>
      </div>
      <div class="bg-white m-5 p-5 rounded-lg border-ccGrey">
        <.form for={@form} phx-submit="save" phx-target={@myself} autocomplete="off">
          <.input type="hidden" name="client_id" field={@form[:id]} />
          <.input type="text" label="Company Name*" name="company_name" placeholder="Company Name" field={@form[:company_name]} required />
          <.input type="email" label="Contact Email" name="contact_email" placeholder="Contact Email" field={@form[:contact_email]}/>
          <.input type="text" label="Phone Number" name="contact_phone_number" placeholder="Phone Number" field={@form[:contact_phone_number]}/>
          <.input class="mb-4" type="date" label="Date Joined" name="date_joined"  field={@form[:date_joined]}/>
          <.button type="submit" class={if @selection.id, do: "bg-ccBlue", else: "bg-ccGreen hover:bg-ccGreen-dark"}><%= if @selection.id, do: "Update Client", else: "New Client" %></.button>
        </.form>
      </div>
    </div>
    """
  end

  def handle_event("save", params, socket) do 
    if params["client_id"] == "" do
      new_client(socket, params)
    else
      update_client(socket, params)
    end
  end

  def handle_event("select", params, socket) do
    if params["id"] == to_string(socket.assigns.selection.id) do # Deselect
      {:noreply, 
        socket
        |> stream_insert(:clients, socket.assigns.selection |> Map.put(:selected, false))
        |> assign(
          selection: %ClientCompany{},
          form: to_form(ClientCompanies.change_client_company(%ClientCompany{}))
        )
      }
    else
      selection = ClientCompanies.get_client_company!(String.to_integer(params["id"]))
      deselect = socket.assigns.selection |> Map.put(:selected, false)
      select = selection |> Map.put(:selected, true)

      {:noreply, 
        socket
        |> stream(:clients, if(deselect.id, do: [deselect, select], else: [select]))
        |> assign(
          selection: selection,
          form: to_form(ClientCompanies.change_client_company(selection))
        ) 
      }
    end
  end

  def handle_event("delete_client", _params, socket) do 
    ClientCompanies.delete_client_company(ClientCompanies.get_client_company!(socket.assigns.selection.id))
    {:noreply, socket |> stream_delete(:clients, socket.assigns.selection) |> assign(selection: %ClientCompany{})}
  end

  defp send_flash(socket, type, message) do
    send(self(), {:put_flash, type, message})
    socket
  end

  defp new_client(socket, params) do
    case ClientCompanies.create_client_company(params) do
      {:ok, client} -> {:noreply, socket 
        |> stream_insert(:clients, client |> Map.put(:selected, false)) 
        |> assign(form: to_form(ClientCompanies.change_client_company(%ClientCompany{})))
        |> send_flash(:info, "New client created!")}
      {:error, changeset} -> {:noreply, socket |> send_flash(:error, "Something went wrong...") |> assign(form: to_form(changeset))}
    end
  end

  defp update_client(socket, params) do
    selected = ClientCompanies.get_client_company!(String.to_integer(params["client_id"]))
    case ClientCompanies.update_client_company(selected, params) do
      {:ok, client} -> {:noreply, socket 
        |> stream_insert(:clients, client |> Map.put(:selected, true)) 
        |> assign(form: to_form(ClientCompanies.change_client_company(client)), selection: client)
        |> send_flash(:info, "Update was successful!")}
      {:error, changeset} -> {:noreply, socket |> send_flash(:error, "Something went wrong...") |> assign(form: to_form(changeset))}
    end
  end
end
