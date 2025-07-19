defmodule VsmTelemetry.System4.Supervisor do
  @moduledoc """
  Supervisor for System 4 (Intelligence) components.
  Manages environmental scanning and future planning.
  """
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    children = [
      # Intelligence monitors
      {VsmTelemetry.System4.EnvironmentScanner, []},
      {VsmTelemetry.System4.FutureProjector, []},
      {VsmTelemetry.System4.ThreatAnalyzer, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end