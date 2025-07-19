defmodule VsmTelemetryWeb.Router do
  use VsmTelemetryWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {VsmTelemetryWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VsmTelemetryWeb do
    pipe_through :browser

    live "/", DashboardLive, :index
    live "/system/:id", SystemLive, :show
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:vsm_telemetry, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: VsmTelemetryWeb.Telemetry
    end
  end
end