defmodule VsmTelemetry.System1.Supervisor do
  @moduledoc """
  Supervisor for System 1 (Operations) components.
  Manages operational units and their telemetry.
  """
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    children = [
      # Operational unit monitors
      {VsmTelemetry.System1.OperationalMonitor, []},
      {VsmTelemetry.System1.PerformanceTracker, []},
      {VsmTelemetry.System1.ResourceMonitor, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end