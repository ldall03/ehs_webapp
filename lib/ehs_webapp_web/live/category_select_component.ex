defmodule EhsWebappWeb.CategorySelectComponent do
  use EhsWebappWeb, :live_component

  alias EhsWebapp.Equipments

  def mount(socket) do # TODO: stream categories
    socket = assign(socket,
      categories: Equipments.list_categories(),
      subcategories: [],
      disabled: true
    )
    {:ok, socket}
  end

  def render(assigns) do 
    ~H"""
    <div>
      <.input type="select" label="Category" name="category_id" phx-blur="cat_change" phx-target={@myself} field={@parent_form[:category_id]}
        options={[{"", ""} | Enum.map(@categories, fn cat -> {cat.category, cat.id} end)]}
      />
      <.input type="hidden" name="subcategory_id" value="" disabled={!@disabled}/>
      <.input type="select" label="Subcategory" name="subcategory_id" id="subcat_select" disabled={@disabled} field={@parent_form[:subcategory_id]}
        options={[ {"", ""} | Enum.map(@subcategories, fn cat -> {cat.subcategory, cat.id} end)]}
      />
    </div>
    """
  end

  def handle_event("cat_change", %{"value" => "" = id} = params, socket) do
    {:noreply, 
      assign(socket, 
        subcategories: [],
        disabled: true)
    }
  end

  def handle_event("cat_change", %{"value" => id} = params, socket) do
    {:noreply,
      assign(socket, 
        subcategories: Equipments.list_subcategories(String.to_integer(id)),
        disabled: false)
    }
  end
end
