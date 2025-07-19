defmodule VsmTelemetry.System3.Supervisor do
  @moduledoc """
  Supervisor for System 3 (Control) components.
  Manages operational control and optimization.
  """
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    children = [
      # Control monitors
      {VsmTelemetry.System3.ControlMonitor, []},
      {VsmTelemetry.System3.OptimizationEngine, []},
      {VsmTelemetry.System3.AuditManager, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end