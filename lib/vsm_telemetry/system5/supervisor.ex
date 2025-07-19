defmodule VsmTelemetry.System5.Supervisor do
  @moduledoc """
  Supervisor for System 5 (Policy) components.
  Manages identity, policy, and strategic direction.
  """
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    children = [
      # Policy monitors
      {VsmTelemetry.System5.PolicyMonitor, []},
      {VsmTelemetry.System5.IdentityManager, []},
      {VsmTelemetry.System5.StrategicPlanner, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end