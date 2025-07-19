defmodule VsmTelemetryWeb.Telemetry do
  use Supervisor
  import Telemetry.Metrics

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      # Telemetry poller will execute the given period measurements
      # every 10_000ms. Learn more here: https://hexdocs.pm/telemetry_metrics
      {:telemetry_poller, measurements: periodic_measurements(), period: 10_000}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def metrics do
    [
      # Phoenix Metrics
      summary("phoenix.endpoint.start.system_time",
        unit: {:native, :millisecond}
      ),
      summary("phoenix.endpoint.stop.duration",
        unit: {:native, :millisecond}
      ),
      summary("phoenix.router_dispatch.start.system_time",
        tags: [:route],
        unit: {:native, :millisecond}
      ),
      summary("phoenix.router_dispatch.exception.duration",
        tags: [:route],
        unit: {:native, :millisecond}
      ),
      summary("phoenix.router_dispatch.stop.duration",
        tags: [:route],
        unit: {:native, :millisecond}
      ),
      summary("phoenix.socket_connected.duration",
        unit: {:native, :millisecond}
      ),
      summary("phoenix.channel_joined.duration",
        unit: {:native, :millisecond}
      ),
      summary("phoenix.channel_handled_in.duration",
        tags: [:event],
        unit: {:native, :millisecond}
      ),

      # VM Metrics
      summary("vm.memory.total", unit: {:byte, :kilobyte}),
      summary("vm.total_run_queue_lengths.total"),
      summary("vm.total_run_queue_lengths.cpu"),
      summary("vm.total_run_queue_lengths.io"),

      # VSM Metrics
      last_value("vsm.system1.operational_units"),
      last_value("vsm.system1.performance_score"),
      last_value("vsm.system1.resource_utilization"),
      last_value("vsm.system1.throughput"),
      
      last_value("vsm.system2.coordination_efficiency"),
      last_value("vsm.system2.variety_handled"),
      last_value("vsm.system2.channel_capacity"),
      last_value("vsm.system2.oscillation_dampening"),
      
      last_value("vsm.system3.control_effectiveness"),
      last_value("vsm.system3.optimization_score"),
      last_value("vsm.system3.audit_compliance"),
      last_value("vsm.system3.synergy_level"),
      
      last_value("vsm.system4.environmental_awareness"),
      last_value("vsm.system4.future_readiness"),
      last_value("vsm.system4.threat_detection"),
      last_value("vsm.system4.opportunity_identification"),
      
      last_value("vsm.system5.policy_coherence"),
      last_value("vsm.system5.identity_strength"),
      last_value("vsm.system5.strategic_alignment"),
      last_value("vsm.system5.ethos_consistency"),
      
      last_value("vsm.overall.viability_index"),
      last_value("vsm.overall.recursion_depth"),
      last_value("vsm.overall.autonomy_level"),
      last_value("vsm.overall.adaptation_rate")
    ]
  end

  defp periodic_measurements do
    [
      # A module, function and arguments to be invoked periodically.
      {VsmTelemetryWeb.Telemetry, :emit_vm_metrics, []}
    ]
  end

  def emit_vm_metrics do
    memory = :erlang.memory()
    run_queue = :erlang.statistics(:run_queue_lengths)
    
    :telemetry.execute([:vm, :memory], %{total: memory[:total]}, %{})
    :telemetry.execute([:vm, :total_run_queue_lengths], %{
      total: Enum.sum(run_queue),
      cpu: hd(run_queue),
      io: 0
    }, %{})
  end
end