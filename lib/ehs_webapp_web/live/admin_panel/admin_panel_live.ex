defmodule EhsWebappWeb.AdminPanelLive do
  use EhsWebappWeb, :live_view

  alias EhsWebapp.Equipments
  alias EhsWebapp.Equipments.{Category, Subcategory}

  def mount(params, _session, socket) do
    view = case params do
      params when params == %{} -> "clients"
      _ -> params["view"]
    end
    socket = assign(socket,
      view: view
    )
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex">
      <div class="bg-ccBlue w-1/6">
        <div class="bg-ccGrey text-white font-bold py-5 w-full text-center">Admin Panel</div>
        <.link 
          class={["font-bold text-center block text-white hover:bg-ccBlue-light w-full py-5", 
          @view == "clients" && "bg-ccBlue-light"]}
          href={~p"/admin_panel/clients"}>Clients
        </.link>
        <.link 
          class={["font-bold text-center block text-white hover:bg-ccBlue-light w-full py-5", 
          @view == "accounts" && "bg-ccBlue-light"]}
          href={~p"/admin_panel/accounts"}>Accounts
        </.link>
        <.link 
          class={["font-bold text-center block text-white hover:bg-ccBlue-light w-full py-5", 
          @view == "equipments" && "bg-ccBlue-light"]}
          href={~p"/admin_panel/equipments"}>Equipments
        </.link>
        <.link 
          class={["font-bold text-center block text-white hover:bg-ccBlue-light w-full py-5", 
          @view == "categories" && "bg-ccBlue-light"]}
          href={~p"/admin_panel/categories"}>Categories
        </.link>
      </div>
      <%= case @view do %>
        <% "clients" -> %>
          <.live_component module={EhsWebappWeb.AdminPanelLive.ClientsComponent} id="clients_components" current_user={@current_user} />
        <% "accounts" -> %>
          <.live_component module={EhsWebappWeb.AdminPanelLive.AccountsComponent} id="accounts_components" current_user={@current_user} />
        <% "equipments" -> %>
          <.live_component module={EhsWebappWeb.AdminPanelLive.EquipmentsComponent} id="equipments_components" current_user={@current_user} />
        <% "categories" -> %>
          <.live_component module={EhsWebappWeb.AdminPanelLive.CategoriesComponent} id="categories_components" current_user={@current_user} />
      <% end %>
    </div>
    """
  end

  def handle_info({:put_flash, type, message}, socket) do
    {:noreply, put_flash(socket, type, message)} 
  end
end
