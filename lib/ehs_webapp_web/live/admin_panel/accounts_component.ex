defmodule EhsWebappWeb.AdminPanelLive.AccountsComponent do
  use EhsWebappWeb, :live_component

  alias EhsWebapp.{Accounts, Accounts.User}

  def mount(socket) do
    socket = assign(socket,
      form: to_form(Accounts.change_user_registration(%User{})),
      gen_pwd: ""
    )
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="bg-ccLight w-5/6">
      <div class="font-bold p-8 text-xl">Accounts</div>
      <.form for={@form} phx-submit="register_user" phx-target={@myself}>
        <div class="flex">
          <.input type="text" label="First Name*" name="f_name" placeholder="First Name" required value="" autocomplete="off" field={@form[:f_name]}/>
          <.input type="text" label="Last Name*" name="l_name" placeholder="Last Name" required value="" autocomplete="off" field={@form[:l_name]}/>
        </div>
        <.input type="email" label="Email*" name="email" placeholder="Email" required value="" autocomplete="off" field={@form[:email]}/>
        <.input type="number" label="Parent Company" name="client_company_id" placeholder="PLACEHOLDER" required value="" autocomplete="off" field={@form[:client_company_id]}/>
        <div class="flex">
          <.input type="text" label="Password" name="password" placeholder="Password" required value={@gen_pwd} autocomplete="off" field={@form[:password]}/>
          <.button phx-click="gen_rand_pwd" type="button" phx-target={@myself}>Gen</.button>
        </div>
        <.input type="checkbox" label="Make Superuser" name="superuser" field={@form[:superuser]} />
        <.button type="submit">Create Account</.button>
      </.form>
    </div>
    """
  end

  def handle_event("register_user", params, socket) do 
    case Accounts.register_user(params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            params["password"],
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("gen_rand_pwd", params, socket) do
    symbols = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    symbol_count = Enum.count(symbols)
    pwd = for _ <- 1..12, into: "", do: <<Enum.at(symbols, :crypto.rand_uniform(0, symbol_count))>>
    socket = assign(socket, gen_pwd: pwd)
    {:noreply, socket}
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
