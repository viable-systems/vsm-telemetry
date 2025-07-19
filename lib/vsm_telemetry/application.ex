defmodule VsmTelemetry.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Configure Prometheus metrics
    setup_prometheus_metrics()

    children = [
      # Start the Telemetry supervisor
      VsmTelemetryWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: VsmTelemetry.PubSub},
      # Start the Endpoint (http/https)
      VsmTelemetryWeb.Endpoint,
      
      # VSM Subsystem Supervisors
      {VsmTelemetry.System1.Supervisor, []},
      {VsmTelemetry.System2.Supervisor, []},
      {VsmTelemetry.System3.Supervisor, []},
      {VsmTelemetry.System4.Supervisor, []},
      {VsmTelemetry.System5.Supervisor, []},
      
      # VSM Metrics Collector
      {VsmTelemetry.MetricsCollector, []},
      
      # Prometheus Exporter
      {VsmTelemetry.PrometheusExporter, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: VsmTelemetry.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VsmTelemetryWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp setup_prometheus_metrics do
    # Setup Prometheus metrics
    :prometheus.start()
    
    # Register custom VSM metrics
    VsmTelemetry.Metrics.setup()
  end
end