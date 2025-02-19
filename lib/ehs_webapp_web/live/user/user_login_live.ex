defmodule EhsWebappWeb.UserLoginLive do
  use EhsWebappWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="flex">
      <div class="w-1/3 p-10">
        <p class="text-ccBlue">Welcome to</p>
        <p class="text-ccBlue text-3xl font-bold">CALiTrak<sup class="text-sm">TM</sup> Digital Platform</p>
        <p class="w-full text-center mt-5 text-xl">Login</p>
        <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
          <.input field={@form[:email]} type="email" label="Email" required />
          <.input field={@form[:password]} type="password" label="Password" required />

          <:actions>
            <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
            <.link href={~p"/users/reset_password"} class="text-sm font-semibold">
              Forgot your password?
            </.link>
          </:actions>
          <:actions>
            <.button phx-disable-with="Logging in..." class="w-full">
              Log in <span aria-hidden="true">→</span>
            </.button>
          </:actions>
        </.simple_form>
      </div>
      <div class="relative w-2/3 bg-ccBlue px-72 py-32">
        <p class="text-white font-bold text-4xl mb-10">Hello!</p>
        <p class="text-white text-xl">Features for Driving Equipment Reliability, Reducing Downtime, and Prolonging Optimal Equipment Lifecycle.</p>
        <hr class="mt-4 w-80">
        <div class="h-96"></div>
        <div class="h-12"></div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
