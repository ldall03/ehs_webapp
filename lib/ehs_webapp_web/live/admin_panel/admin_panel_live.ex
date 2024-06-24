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
    IO.inspect(params)
    IO.puts(view)
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
          href={~p"/admin_panel/clients"}>Accounts
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
        <.link 
          class={["font-bold text-center block text-white hover:bg-ccBlue-light w-full py-5", 
          @view == "ownerships" && "bg-ccBlue-light"]}
          href={~p"/admin_panel/ownerships"}>Ownerships
        </.link>
      </div>
      <%= case @view do %>
        <% "clients" -> %>
          <.live_component module={EhsWebappWeb.AdminPanelLive.ClientsComponent} id="clients_components" />
        <% "accounts" -> %>
          <.live_component module={EhsWebappWeb.AdminPanelLive.ClientsComponent} id="accounts_components" />
        <% "equipments" -> %>
          <.live_component module={EhsWebappWeb.AdminPanelLive.EquipmentsComponent} id="equipments_components" />
        <% "categories" -> %>
          <.live_component module={EhsWebappWeb.AdminPanelLive.CategoriesComponent} id="categories_components" />
        <% "ownerships" -> %>
          <.live_component module={EhsWebappWeb.AdminPanelLive.OwnershipsComponent} id="ownerships_components" />
      <% end %>
    </div>
    """
  end
end
