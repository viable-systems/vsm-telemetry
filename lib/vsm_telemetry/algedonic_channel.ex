defmodule VsmTelemetry.AlgedonicChannel do
  @moduledoc """
  Implements the algedonic (pain/pleasure) signal channel for VSM.
  Provides bypass communication for critical signals.
  """
  
  use GenServer
  require Logger
  
  @critical_threshold 0.9
  @warning_threshold 0.7
  
  # Client API
  
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end
  
  def signal(severity, source, message) when severity in [:critical, :warning, :info] do
    GenServer.cast(__MODULE__, {:signal, severity, source, message})
  end
  
  def get_active_signals(limit \\ 10) do
    GenServer.call(__MODULE__, {:get_active_signals, limit})
  end
  
  def acknowledge_signal(signal_id) do
    GenServer.cast(__MODULE__, {:acknowledge, signal_id})
  end
  
  # Server Callbacks
  
  @impl true
  def init(_opts) do
    state = %{
      signals: [],
      acknowledged: MapSet.new(),
      signal_counter: 0
    }
    
    {:ok, state}
  end
  
  @impl true
  def handle_cast({:signal, severity, source, message}, state) do
    signal = %{
      id: state.signal_counter + 1,
      severity: severity,
      source: source,
      message: message,
      timestamp: DateTime.utc_now(),
      acknowledged: false
    }
    
    # Add to signals list
    new_signals = [signal | state.signals] |> Enum.take(1000)
    
    # Broadcast critical signals
    if severity == :critical do
      bypass_to_system5(signal)
      Phoenix.PubSub.broadcast(
        VsmTelemetry.PubSub,
        "algedonic:critical",
        {:algedonic_signal, signal}
      )
    end
    
    # Update telemetry
    :telemetry.execute(
      [:vsm, :algedonic, :signal],
      %{count: 1},
      %{severity: severity, source: source}
    )
    
    Logger.warning("Algedonic signal: #{severity} from #{source} - #{message}")
    
    {:noreply, %{state | 
      signals: new_signals,
      signal_counter: state.signal_counter + 1
    }}
  end
  
  @impl true
  def handle_cast({:acknowledge, signal_id}, state) do
    acknowledged = MapSet.put(state.acknowledged, signal_id)
    
    signals = Enum.map(state.signals, fn signal ->
      if signal.id == signal_id do
        %{signal | acknowledged: true}
      else
        signal
      end
    end)
    
    {:noreply, %{state | signals: signals, acknowledged: acknowledged}}
  end
  
  @impl true
  def handle_call({:get_active_signals, limit}, _from, state) do
    active_signals = state.signals
    |> Enum.reject(& &1.acknowledged)
    |> Enum.take(limit)
    
    {:reply, active_signals, state}
  end
  
  # Private Functions
  
  defp bypass_to_system5(signal) do
    # Direct bypass to System 5 for critical signals
    case GenServer.whereis(VsmTelemetry.System5.PolicyMonitor) do
      nil -> 
        Logger.error("System 5 not available for algedonic bypass!")
      pid ->
        send(pid, {:algedonic_bypass, signal})
    end
  end
end