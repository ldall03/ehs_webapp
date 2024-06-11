defmodule EhsWebappWeb.AdminPanelLive do
  use EhsWebappWeb, :live_view

  alias EhsWebapp.Equipments
  alias EhsWebapp.Equipments.{Category, Subcategory}

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex">
      <div class="bg-ccBlue w-1/6">
        <div class="bg-ccGrey text-white font-bold py-5 w-full text-center">Admin Panel</div>
        <.button class="text-white hover:bg-ccBlue-light rounded-none w-full py-5">Clients</.button>
        <.button class="text-white hover:bg-ccBlue-light rounded-none w-full py-5">Accounts</.button>
        <.button class="text-white hover:bg-ccBlue-light rounded-none w-full py-5">Equipments</.button>
        <.button class="text-white hover:bg-ccBlue-light rounded-none w-full py-5">Categories</.button>
        <.button class="text-white hover:bg-ccBlue-light rounded-none w-full py-5">Ownerships?</.button>
      </div>
      <.live_component module={EhsWebappWeb.AdminPanelLive.OwnershipsComponent} id="testing_components" />
    </div>
    """
  end
end
