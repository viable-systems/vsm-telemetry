defmodule VsmTelemetryWeb.DashboardLive do
  use VsmTelemetryWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      # Subscribe to real-time metrics via PubSub
      Phoenix.PubSub.subscribe(VsmTelemetry.PubSub, "vsm:metrics")
      
      # Subscribe to VSM metrics via telemetry
      :telemetry.attach(
        "dashboard-vsm-metrics-#{inspect(self())}",
        [:vsm, :metrics],
        &handle_vsm_metrics/4,
        %{socket_pid: self()}
      )
      
      # Schedule periodic refresh as fallback
      :timer.send_interval(2000, self(), :refresh)
    end

    # Get current metrics if available
    current_metrics = try do
      VsmTelemetry.MetricsCollector.get_current_metrics()
    rescue
      _ -> initial_metrics()
    end

    {:ok, assign(socket, 
      metrics: current_metrics,
      last_update: DateTime.utc_now(),
      connected: connected?(socket),
      update_count: 0
    )}
  end

  @impl true
  def handle_info(:refresh, socket) do
    # Fallback refresh - get latest metrics if we missed updates
    current_metrics = try do
      VsmTelemetry.MetricsCollector.get_current_metrics()
    rescue
      _ -> socket.assigns.metrics
    end
    
    {:noreply, assign(socket, 
      metrics: current_metrics, 
      last_update: DateTime.utc_now()
    )}
  end

  @impl true
  def handle_info({:metrics_update, metrics}, socket) do
    # Real-time update from PubSub
    {:noreply, assign(socket, 
      metrics: metrics,
      last_update: DateTime.utc_now(),
      update_count: socket.assigns.update_count + 1
    )}
  end

  @impl true
  def handle_info({:vsm_metrics, metrics}, socket) do
    # Telemetry-based update
    {:noreply, assign(socket, 
      metrics: metrics,
      last_update: DateTime.utc_now(),
      update_count: socket.assigns.update_count + 1
    )}
  end

  defp handle_vsm_metrics(_event_name, measurements, metadata, config) do
    if config[:socket_pid] do
      send(config[:socket_pid], {:vsm_metrics, measurements})
    end
  end

  defp initial_metrics do
    %{
      system1: %{
        operational_units: 0,
        performance_score: 0,
        resource_utilization: 0,
        throughput: 0
      },
      system2: %{
        coordination_efficiency: 0,
        variety_handled: 0,
        channel_capacity: 0,
        oscillation_dampening: 0
      },
      system3: %{
        control_effectiveness: 0,
        optimization_score: 0,
        audit_compliance: 0,
        synergy_level: 0
      },
      system4: %{
        environmental_awareness: 0,
        future_readiness: 0,
        threat_detection: 0,
        opportunity_identification: 0
      },
      system5: %{
        policy_coherence: 0,
        identity_strength: 0,
        strategic_alignment: 0,
        ethos_consistency: 0
      },
      overall: %{
        viability_index: 0,
        recursion_depth: 0,
        autonomy_level: 0,
        adaptation_rate: 0
      }
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="vsm-dashboard">
      <h1 class="text-3xl font-bold mb-6">VSM Telemetry Dashboard</h1>
      
      <div class="overall-metrics mb-8">
        <h2 class="text-2xl font-semibold mb-4">Overall System Health</h2>
        <div class="grid grid-cols-4 gap-4">
          <div class="metric-card">
            <h3>Viability Index</h3>
            <p class="text-3xl"><%= @metrics.overall.viability_index %>%</p>
          </div>
          <div class="metric-card">
            <h3>Recursion Depth</h3>
            <p class="text-3xl"><%= @metrics.overall.recursion_depth %></p>
          </div>
          <div class="metric-card">
            <h3>Autonomy Level</h3>
            <p class="text-3xl"><%= @metrics.overall.autonomy_level %>%</p>
          </div>
          <div class="metric-card">
            <h3>Adaptation Rate</h3>
            <p class="text-3xl"><%= @metrics.overall.adaptation_rate %>%</p>
          </div>
        </div>
      </div>
      
      <div class="systems-grid grid grid-cols-3 gap-6">
        <.system_card system="System 1" subtitle="Operations" metrics={@metrics.system1} />
        <.system_card system="System 2" subtitle="Coordination" metrics={@metrics.system2} />
        <.system_card system="System 3" subtitle="Control" metrics={@metrics.system3} />
        <.system_card system="System 4" subtitle="Intelligence" metrics={@metrics.system4} />
        <.system_card system="System 5" subtitle="Policy" metrics={@metrics.system5} />
      </div>
    </div>
    """
  end

  defp system_card(assigns) do
    ~H"""
    <div class="system-card bg-white rounded-lg shadow p-6">
      <h3 class="text-xl font-semibold mb-2"><%= @system %></h3>
      <p class="text-gray-600 mb-4"><%= @subtitle %></p>
      <div class="metrics-list">
        <%= for {key, value} <- @metrics do %>
          <div class="metric-item flex justify-between py-1">
            <span class="text-gray-700"><%= humanize(key) %></span>
            <span class="font-mono"><%= value %></span>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp humanize(atom) do
    atom
    |> Atom.to_string()
    |> String.replace("_", " ")
    |> String.capitalize()
  end
end