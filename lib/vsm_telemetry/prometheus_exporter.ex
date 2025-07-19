defmodule VsmTelemetry.PrometheusExporter do
  @moduledoc """
  Prometheus exporter for VSM metrics.
  Sets up and manages Prometheus metrics for the VSM.
  """
  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    # Prometheus metrics are already set up in MetricsCollector
    Logger.info("Prometheus exporter initialized")
    {:ok, %{}}
  end
end