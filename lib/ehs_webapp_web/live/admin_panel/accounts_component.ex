defmodule EhsWebappWeb.AdminPanelLive.AccountsComponent do
  use EhsWebappWeb, :live_component

  alias EhsWebapp.{Accounts, Accounts.User}
  alias EhsWebapp.ClientCompanies

  def mount(socket) do
    {:ok, socket 
      |> assign(
        form: to_form(%{}),
        gen_pwd: "",
        selection: %User{},
        client_companies: ClientCompanies.list_client_companies())
      |> stream(:accounts, 
        Accounts.list_users() |> Enum.map(fn i -> 
          %{id: i.id, 
            email: i.email, 
            f_name: i.f_name, 
            l_name: i.l_name, 
            selected: false}
        end)
      )
    }
  end

  def render(assigns) do
    ~H"""
    <div class="bg-ccLight w-5/6">
      <div class="font-bold p-8 text-xl">Accounts</div>
      <div class="bg-white m-5 pt-5 rounded-lg border-ccGrey">
        <div class="flex justify-between py-4">
          <p class="w-full text-center font-bold">First Name</p>
          <p class="w-full text-center font-bold">Last Name</p>
          <p class="w-full text-center font-bold">Email</p>
        </div>
        <div id="clients" phx-update="stream" class="h-96 overflow-scroll">
          <%= for {dom_id, account} <- @streams.accounts do %>
            <div class={["flex justify-between py-3 m-1 rounded select-none", account.selected && "bg-ccBlue text-white"]} phx-value-id={account.id} phx-click="select" phx-target={@myself} id={dom_id}>
              <p class="w-full text-center cursor-default"><%= account.f_name %></p>
              <p class="w-full text-center cursor-default"><%= account.l_name %></p>
              <p class="w-full text-center cursor-default"><%= account.email %></p>
            </div>
          <% end %>
        </div>
        <div :if={@current_user.superuser} class="text-right">
          <.button phx-click="delete_user" phx-target={@myself} data-confirm="Are you sure you want to delete the user? This is irreversible." class="m-5 bg-ccRed hover:bg-ccRed-dark disabled:bg-ccGrey disabled:hover:bg-ccGrey disabled:active:text-white" disabled={!@selection.id}>Delete User</.button>
        </div>
      </div>
      <div class="bg-white m-5 p-5 rounded-lg border-ccGrey">
        <.form for={@form} phx-submit="register" phx-change="validate" phx-target={@myself} autocomplete="off">
          <.input phx-debounce="blur" type="text" label="First Name*" name="f_name" placeholder="First Name" required field={@form[:f_name]}/>
          <.input phx-debounce="blur" type="text" label="Last Name*" name="l_name" placeholder="Last Name" required field={@form[:l_name]}/>
          <.input phx-debounce="blur" type="email" label="Email*" name="email" placeholder="Email" required field={@form[:email]}/>
          <.select_input id="client_company_select" label="Employer Company*" name="client_company_id" field={@form[:client_company_id]} placeholder="Employer Company" 
            options={Enum.map(@client_companies, fn i -> {i.company_name, i.id} end)}
          />
          <div class="relative pb-2">
            <.input type="text" label="Password" name="password" placeholder="Password" required field={@form[:password]} class="h-11" />
            <.button type="button" phx-click="gen_rand_pwd" phx-target={@myself} class="absolute top-8 right-0 text-xs text-ccGrey-light bg-ccGrey hover:bg-ccGrey-light h-11 border border-none rounded-none rounded-r-md">Gen</.button>
          </div>
          <.input type="checkbox" label="Make Admin" name="admin" field={@form[:admin]}/>
          <.button value="register" class="bg-ccGreen hover:bg-ccGreen-dark mt-2">New Account</.button>
        </.form>
      </div>
    </div>
    """
  end

  def handle_event("select", params, socket) do
    if params["id"] == to_string(socket.assigns.selection.id) do # Deselect
      {:noreply, 
        socket
        |> stream_insert(:accounts, socket.assigns.selection |> Map.put(:selected, false))
        |> assign(selection: %User{})
      }
    else
      selection = Accounts.get_user!(String.to_integer(params["id"]))
      deselect = socket.assigns.selection |> Map.put(:selected, false)
      select = selection |> Map.put(:selected, true)

      {:noreply, 
        socket
        |> stream(:accounts, if(deselect.id, do: [deselect, select], else: [select]))
        |> assign(selection: selection) 
      }
    end
  end

  def handle_event("validate", params, socket) do
    {:noreply, assign(socket, form: to_form(params))}
  end

  def handle_event("register", params, socket) do 
    case Accounts.register_user(params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            params["password"],
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(%User{})
        {:noreply, socket 
          |> assign(trigger_submit: true) 
          |> assign_form(changeset) 
          |> stream_insert(:accounts, Map.put(user, :selected, false))
          |> send_flash(:info, "New account created!")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset) |> send_flash(:error, "Something went wrong...")}
    end
  end

  def handle_event("delete_user", _params, socket) do 
    Accounts.delete_user(Accounts.get_user!(socket.assigns.selection.id))
    {:noreply, socket |> stream_delete(:accounts, socket.assigns.selection) |> assign(selection: %User{})}
  end

  def handle_event("gen_rand_pwd", params, socket) do
    symbols = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    symbol_count = Enum.count(symbols)
    pwd = for _ <- 1..12, into: "", do: <<Enum.at(symbols, :crypto.rand_uniform(0, symbol_count))>>
    {:noreply, assign(socket, form: to_form(socket.assigns.form.source |> Map.put("password", pwd)))}
  end

  defp send_flash(socket, type, message) do
    send(self(), {:put_flash, type, message})
    socket
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
