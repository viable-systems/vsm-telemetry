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
    setup_prometheus_metrics()
    {:ok, %{}}
  end

  defp setup_prometheus_metrics do
    # System 1 metrics
    :prometheus_gauge.new([
      name: [:vsm, :system1, :operational_units],
      help: "Number of operational units in System 1"
    ])
    
    :prometheus_gauge.new([
      name: [:vsm, :system1, :performance_score],
      help: "Overall performance score of System 1"
    ])
    
    :prometheus_gauge.new([
      name: [:vsm, :system1, :resource_utilization],
      help: "Resource utilization percentage in System 1"
    ])
    
    :prometheus_gauge.new([
      name: [:vsm, :system1, :throughput],
      help: "Throughput of System 1 operations"
    ])
    
    # System 2 metrics
    :prometheus_gauge.new([
      name: [:vsm, :system2, :coordination_efficiency],
      help: "Coordination efficiency percentage"
    ])
    
    :prometheus_gauge.new([
      name: [:vsm, :system2, :variety_handled],
      help: "Amount of variety being handled"
    ])
    
    :prometheus_gauge.new([
      name: [:vsm, :system2, :channel_capacity],
      help: "Communication channel capacity utilization"
    ])
    
    :prometheus_gauge.new([
      name: [:vsm, :system2, :oscillation_dampening],
      help: "Oscillation dampening effectiveness"
    ])
    
    # System 3 metrics
    :prometheus_gauge.new([
      name: [:vsm, :system3, :control_effectiveness],
      help: "Control system effectiveness"
    ])
    
    :prometheus_gauge.new([
      name: [:vsm, :system3, :optimization_score],
      help: "Optimization score"
    ])
    
    :prometheus_gauge.new([
      name: [:vsm, :system3, :audit_compliance],
      help: "Audit compliance percentage"
    ])
    
    :prometheus_gauge.new([
      name: [:vsm, :system3, :synergy_level],
      help: "Synergy level between operational units"
    ])
    
    # System 4 metrics
    :prometheus_gauge.new([
      name: [:vsm, :system4, :environmental_awareness],
      help: "Environmental awareness score"
    ])
    
    :prometheus_gauge.new([
      name: [:vsm, :system4, :future_readiness],
      help: "Future readiness score"
    ])
    
    :prometheus_gauge.new([
      name: [:vsm, :system4, :threat_detection],
      help: "Threat detection capability"
    ])
    
    :prometheus_gauge.new([
      name: [:vsm, :system4, :opportunity_identification],
      help: "Opportunity identification score"
    ])
    
    # System 5 metrics
    :prometheus_gauge.new([
      name: [:vsm, :system5, :policy_coherence],
      help: "Policy coherence score"
    ])
    
    :prometheus_gauge.new([
      name: [:vsm, :system5, :identity_strength],
      help: "Organizational identity strength"
    ])
    
    :prometheus_gauge.new([
      name: [:vsm, :system5, :strategic_alignment],
      help: "Strategic alignment score"
    ])
    
    :prometheus_gauge.new([
      name: [:vsm, :system5, :ethos_consistency],
      help: "Ethos consistency score"
    ])
    
    # Overall VSM metrics
    :prometheus_gauge.new([
      name: [:vsm, :overall, :viability_index],
      help: "Overall system viability index"
    ])
    
    :prometheus_gauge.new([
      name: [:vsm, :overall, :recursion_depth],
      help: "Current recursion depth"
    ])
    
    :prometheus_gauge.new([
      name: [:vsm, :overall, :autonomy_level],
      help: "System autonomy level"
    ])
    
    :prometheus_gauge.new([
      name: [:vsm, :overall, :adaptation_rate],
      help: "System adaptation rate"
    ])
    
    Logger.info("Prometheus metrics initialized for VSM")
  end
end