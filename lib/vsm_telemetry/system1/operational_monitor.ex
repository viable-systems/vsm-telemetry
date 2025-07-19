defmodule VsmTelemetry.System1.OperationalMonitor do
  @moduledoc """
  Monitors operational units in System 1.
  Tracks performance, resource usage, and throughput.
  """
  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    # Schedule periodic monitoring
    schedule_monitoring()
    
    {:ok, %{
      units: [],
      performance_data: %{},
      resource_usage: %{}
    }}
  end

  @impl true
  def handle_info(:monitor, state) do
    # Collect operational data
    performance = measure_performance(state.units)
    resources = measure_resource_usage(state.units)
    
    # Emit telemetry events
    :telemetry.execute(
      [:vsm, :system1, :operational],
      %{
        performance: performance,
        resources: resources,
        unit_count: length(state.units)
      },
      %{}
    )
    
    # Update Prometheus metrics
    VsmTelemetry.Metrics.record_operation(:system1, :monitor, :success, 0)
    
    # Schedule next monitoring
    schedule_monitoring()
    
    {:noreply, %{state | 
      performance_data: performance,
      resource_usage: resources
    }}
  end

  defp measure_performance(_units) do
    # Simulate performance measurement
    %{
      throughput: :rand.uniform(1000),
      latency: :rand.uniform(100),
      error_rate: :rand.uniform(10) / 100
    }
  end

  defp measure_resource_usage(_units) do
    # Simulate resource usage measurement
    %{
      cpu: :rand.uniform(100),
      memory: :rand.uniform(100),
      io: :rand.uniform(100)
    }
  end

  defp schedule_monitoring do
    Process.send_after(self(), :monitor, 5_000)
  end
end