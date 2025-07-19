defmodule VsmTelemetry.VarietyCalculator do
  @moduledoc """
  Calculates variety metrics for VSM systems using Shannon entropy
  and Ashby's Law of Requisite Variety.
  """
  
  use GenServer
  require Logger
  
  # Client API
  
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end
  
  def calculate_variety(system_id, states) do
    GenServer.call(__MODULE__, {:calculate_variety, system_id, states})
  end
  
  def calculate_requisite_variety(controller_states, controlled_states) do
    GenServer.call(__MODULE__, {:calculate_requisite_variety, controller_states, controlled_states})
  end
  
  def get_variety_ratio(system_id) do
    GenServer.call(__MODULE__, {:get_variety_ratio, system_id})
  end
  
  # Server Callbacks
  
  @impl true
  def init(_opts) do
    state = %{
      variety_history: %{},
      ratios: %{},
      last_calculation: nil
    }
    
    # Schedule periodic calculations
    schedule_calculation()
    
    {:ok, state}
  end
  
  @impl true
  def handle_call({:calculate_variety, system_id, states}, _from, state) do
    variety = calculate_shannon_entropy(states)
    
    # Update history
    history = Map.get(state.variety_history, system_id, [])
    timestamp = System.monotonic_time(:millisecond)
    updated_history = [{timestamp, variety} | history] |> Enum.take(1000)
    
    new_state = %{state | 
      variety_history: Map.put(state.variety_history, system_id, updated_history),
      last_calculation: timestamp
    }
    
    # Record metric
    VsmTelemetry.Metrics.record_variety_absorbed(system_id, variety)
    
    {:reply, {:ok, variety}, new_state}
  end
  
  @impl true
  def handle_call({:calculate_requisite_variety, controller_states, controlled_states}, _from, state) do
    controller_variety = calculate_shannon_entropy(controller_states)
    controlled_variety = calculate_shannon_entropy(controlled_states)
    
    ratio = if controlled_variety > 0 do
      controller_variety / controlled_variety
    else
      :infinity
    end
    
    {:reply, {:ok, %{
      controller_variety: controller_variety,
      controlled_variety: controlled_variety,
      ratio: ratio,
      sufficient: ratio >= 1.0
    }}, state}
  end
  
  @impl true
  def handle_call({:get_variety_ratio, system_id}, _from, state) do
    ratio = Map.get(state.ratios, system_id, 0.0)
    {:reply, {:ok, ratio}, state}
  end
  
  @impl true
  def handle_info(:calculate_periodic, state) do
    # Calculate variety for all active systems
    for system_id <- [:system1, :system2, :system3, :system4, :system5] do
      # Get current states from each system
      case get_system_states(system_id) do
        {:ok, states} ->
          calculate_variety(system_id, states)
        _ ->
          :ok
      end
    end
    
    # Schedule next calculation
    schedule_calculation()
    
    {:noreply, state}
  end
  
  # Private Functions
  
  defp calculate_shannon_entropy(states) when is_list(states) do
    # Count occurrences of each state
    frequencies = Enum.frequencies(states)
    total = Enum.count(states)
    
    if total == 0 do
      0.0
    else
      # Calculate Shannon entropy: H = -Σ(p_i * log2(p_i))
      frequencies
      |> Enum.map(fn {_state, count} ->
        probability = count / total
        -probability * :math.log2(probability)
      end)
      |> Enum.sum()
    end
  end
  
  defp get_system_states(system_id) do
    # Query the appropriate system for its current states
    case system_id do
      :system1 -> VsmTelemetry.System1.OperationalMonitor.get_states()
      :system2 -> VsmTelemetry.System2.VarietyManager.get_states()
      :system3 -> VsmTelemetry.System3.ControlMonitor.get_states()
      :system4 -> VsmTelemetry.System4.EnvironmentScanner.get_states()
      :system5 -> VsmTelemetry.System5.PolicyMonitor.get_states()
      _ -> {:error, :unknown_system}
    end
  end
  
  defp schedule_calculation do
    Process.send_after(self(), :calculate_periodic, 5_000) # Every 5 seconds
  end
end