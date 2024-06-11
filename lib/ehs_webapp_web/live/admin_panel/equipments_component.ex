defmodule EhsWebappWeb.AdminPanelLive.EquipmentsComponent do
  use EhsWebappWeb, :live_component
  
  alias EhsWebapp.{Equipments, Equipments.Equipment}

  def mount(socket) do
    socket = assign(socket,
      form: to_form(Equipments.change_equipment(%Equipment{})),
      categories: Equipments.list_categories(),
      subcategories: [],
      disabled: true
    )
    {:ok, socket}
  end

  def render(assigns) do # TODO[maybe]: refactor the select
    ~H"""
    <div class="bg-ccLight w-5/6">
      <div class="font-bold p-8 text-xl">Equipments</div>
      <.form for={@form} phx-submit="new_equipment" phx-target={@myself}>
        <.input type="text" label="Equipment Name*" name="equipment" placeholder="Equipment Name" value="" autocomplete="off" field={@form[:equipment]}/>
        <.live_component module={EhsWebappWeb.CategorySelectComponent} id="category_select" />
        <.input type="text" label="Brand*" name="brand" placeholder="Brand" value="" autocomplete="off" field={@form[:brand]}/>
        <.input type="textarea" label="Description" name="description" placeholder="Description..." value="" autocomplete="off" field={@form[:description]}/>
        <.button type="submit">Add Equipment</.button>
      </.form>
    </div>
    """
  end

  def handle_event("new_equipment", params, socket) do # TODO[con]: reset form
    Equipments.create_equipment(Map.delete(params, "category_id"))
    {:noreply, socket}
  end
end
