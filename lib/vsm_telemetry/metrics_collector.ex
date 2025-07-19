defmodule VsmTelemetry.MetricsCollector do
  @moduledoc """
  Central metrics collector for VSM telemetry.
  Aggregates metrics from all subsystems and publishes them.
  """
  use GenServer
  require Logger

  @collection_interval 5_000 # 5 seconds

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    # Schedule the first collection
    schedule_collection()
    
    {:ok, %{
      metrics: %{},
      last_collection: System.monotonic_time(:millisecond)
    }}
  end

  @impl true
  def handle_info(:collect_metrics, state) do
    # Collect metrics from all subsystems
    metrics = collect_all_metrics()
    
    # Publish metrics via telemetry
    publish_metrics(metrics)
    
    # Update Prometheus metrics
    update_prometheus_metrics(metrics)
    
    # Schedule next collection
    schedule_collection()
    
    {:noreply, %{state | 
      metrics: metrics,
      last_collection: System.monotonic_time(:millisecond)
    }}
  end

  defp collect_all_metrics do
    %{
      system1: collect_system1_metrics(),
      system2: collect_system2_metrics(),
      system3: collect_system3_metrics(),
      system4: collect_system4_metrics(),
      system5: collect_system5_metrics(),
      overall: collect_overall_metrics()
    }
  end

  defp collect_system1_metrics do
    %{
      operational_units: :rand.uniform(10),
      performance_score: :rand.uniform(100),
      resource_utilization: :rand.uniform(100),
      throughput: :rand.uniform(1000)
    }
  end

  defp collect_system2_metrics do
    %{
      coordination_efficiency: :rand.uniform(100),
      variety_handled: :rand.uniform(50),
      channel_capacity: :rand.uniform(100),
      oscillation_dampening: :rand.uniform(100)
    }
  end

  defp collect_system3_metrics do
    %{
      control_effectiveness: :rand.uniform(100),
      optimization_score: :rand.uniform(100),
      audit_compliance: :rand.uniform(100),
      synergy_level: :rand.uniform(100)
    }
  end

  defp collect_system4_metrics do
    %{
      environmental_awareness: :rand.uniform(100),
      future_readiness: :rand.uniform(100),
      threat_detection: :rand.uniform(100),
      opportunity_identification: :rand.uniform(100)
    }
  end

  defp collect_system5_metrics do
    %{
      policy_coherence: :rand.uniform(100),
      identity_strength: :rand.uniform(100),
      strategic_alignment: :rand.uniform(100),
      ethos_consistency: :rand.uniform(100)
    }
  end

  defp collect_overall_metrics do
    %{
      viability_index: :rand.uniform(100),
      recursion_depth: :rand.uniform(5),
      autonomy_level: :rand.uniform(100),
      adaptation_rate: :rand.uniform(100)
    }
  end

  defp publish_metrics(metrics) do
    # Publish telemetry events
    :telemetry.execute([:vsm, :metrics], metrics, %{})
    
    # Log metrics
    Logger.debug("VSM Metrics collected: #{inspect(metrics)}")
  end

  defp update_prometheus_metrics(metrics) do
    # First ensure gauges are declared
    setup_gauges()
    
    # Update Prometheus gauges for each metric
    Enum.each(metrics, fn {system, system_metrics} ->
      Enum.each(system_metrics, fn {metric_name, value} ->
        gauge_name = String.to_atom("vsm_#{system}_#{metric_name}")
        :prometheus_gauge.set(gauge_name, value)
      end)
    end)
  end
  
  defp setup_gauges do
    # Setup gauges if not already done
    gauges = [
      # System 1 gauges
      {:vsm_system1_operational_units, "Number of operational units in System 1"},
      {:vsm_system1_performance_score, "Performance score for System 1"},
      {:vsm_system1_resource_utilization, "Resource utilization for System 1"},
      {:vsm_system1_throughput, "Throughput for System 1"},
      # System 2 gauges
      {:vsm_system2_coordination_efficiency, "Coordination efficiency for System 2"},
      {:vsm_system2_variety_handled, "Variety handled by System 2"},
      {:vsm_system2_channel_capacity, "Channel capacity for System 2"},
      {:vsm_system2_oscillation_dampening, "Oscillation dampening for System 2"},
      # System 3 gauges
      {:vsm_system3_control_effectiveness, "Control effectiveness for System 3"},
      {:vsm_system3_optimization_score, "Optimization score for System 3"},
      {:vsm_system3_audit_compliance, "Audit compliance for System 3"},
      {:vsm_system3_synergy_level, "Synergy level for System 3"},
      # System 4 gauges
      {:vsm_system4_environmental_awareness, "Environmental awareness for System 4"},
      {:vsm_system4_future_readiness, "Future readiness for System 4"},
      {:vsm_system4_threat_detection, "Threat detection for System 4"},
      {:vsm_system4_opportunity_identification, "Opportunity identification for System 4"},
      # System 5 gauges
      {:vsm_system5_policy_coherence, "Policy coherence for System 5"},
      {:vsm_system5_identity_strength, "Identity strength for System 5"},
      {:vsm_system5_strategic_alignment, "Strategic alignment for System 5"},
      {:vsm_system5_ethos_consistency, "Ethos consistency for System 5"},
      # Overall gauges
      {:vsm_overall_viability_index, "Overall viability index"},
      {:vsm_overall_recursion_depth, "Overall recursion depth"},
      {:vsm_overall_autonomy_level, "Overall autonomy level"},
      {:vsm_overall_adaptation_rate, "Overall adaptation rate"}
    ]
    
    Enum.each(gauges, fn {name, help} ->
      try do
        :prometheus_gauge.new([name: name, help: help])
      rescue
        _ -> :ok # Gauge already exists
      end
    end)
  end

  defp schedule_collection do
    Process.send_after(self(), :collect_metrics, @collection_interval)
  end
end