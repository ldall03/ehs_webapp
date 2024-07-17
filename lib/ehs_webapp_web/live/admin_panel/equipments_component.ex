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

  def render(assigns) do 
    ~H"""
    <div class="bg-ccLight w-5/6">
      <div class="font-bold p-8 text-xl">Equipments</div>
      <.form id="equipment_form" for={@form} phx-submit="new_equipment" phx-change="validate" phx-target={@myself} autocomplete="off">
        <.input type="text" phx-debounce="blur" label="Equipment Name*" placeholder="Equipment Name..." name="equipment" field={@form[:equipment]} />
        <.live_component module={EhsWebappWeb.CategorySelectComponent} id="category_select" parent_form={@form} />
        <.input type="text" phx-debounce="blur" label="Brand*" placeholder="Brand..." name="brand" field={@form[:brand]} />
        <.button type="submit">Add Equipment</.button>
      </.form>
    </div>
    """
  end

  def handle_event("validate", params, socket) do
    {:noreply, assign(socket, form: to_form(params))}
  end

  def handle_event("new_equipment", params, socket) do 
    Equipments.create_equipment(params)
    {:noreply, assign(socket, form: to_form(%Equipment{}))}
  end
end
