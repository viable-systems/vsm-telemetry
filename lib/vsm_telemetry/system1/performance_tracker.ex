defmodule VsmTelemetry.System1.PerformanceTracker do
  @moduledoc """
  Tracks performance metrics for System 1 operations.
  """
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    {:ok, %{metrics: []}}
  end

  def track_operation(operation, duration) do
    GenServer.cast(__MODULE__, {:track, operation, duration})
  end

  @impl true
  def handle_cast({:track, operation, duration}, state) do
    VsmTelemetry.Metrics.record_operation(:system1, operation, :success, duration)
    {:noreply, %{state | metrics: [{operation, duration} | state.metrics]}}
  end
end