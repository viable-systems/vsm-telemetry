defmodule VsmTelemetry.System2.Supervisor do
  @moduledoc """
  Supervisor for System 2 (Coordination) components.
  Manages coordination between operational units.
  """
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    children = [
      # Coordination monitors
      {VsmTelemetry.System2.CoordinationMonitor, []},
      {VsmTelemetry.System2.VarietyManager, []},
      {VsmTelemetry.System2.ChannelMonitor, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end