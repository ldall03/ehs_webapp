defmodule EhsWebappWeb.CategorySelectComponent do
  use EhsWebappWeb, :live_component
  alias EhsWebapp.Equipments
  def mount(socket) do
    socket = assign(socket,
      categories: Equipments.list_categories(),
      subcategories: [],
      disabled: true
    )
    {:ok, socket}
  end

  def render(assigns) do # TODO[maybe]: refactor the select
    ~H"""
    <div>
      <.input type="select" label="Category" name="category_id" value="" phx-change="cat_change" phx-target={@myself}
        options={[{"", ""} | Enum.map(@categories, fn cat -> {cat.category, cat.id} end)]}
      />
      <.input type="hidden" name="subcategory_id" value="" disabled={!@disabled}/>
      <.input type="select" label="Subcategory" name="subcategory_id" value="" id="subcat_select" disabled={@disabled}
        options={[ {"", ""} | Enum.map(@subcategories, fn cat -> {cat.subcategory, cat.id} end)]}
      />
    </div>
    """
  end

  def handle_event("cat_change", %{"_target" => _t, "category_id" => ""}, socket) do
    socket = assign(socket, 
      subcategories: [],
      disabled: true
    )
    {:noreply, socket}
  end

  def handle_event("cat_change", %{"_target" => _t, "category_id" => id}, socket) do
    subcategories = Equipments.list_subcategories(String.to_integer(id))
    socket = assign(socket, 
      subcategories: subcategories,
      disabled: false
    )
    {:noreply, socket}
  end
end
