defmodule EhsWebappWeb.PageController do
  use EhsWebappWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home)
  end

  def contact_us(conn, _params) do
    render(conn, :contact_us)
  end
end
