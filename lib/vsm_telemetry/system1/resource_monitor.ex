defmodule VsmTelemetry.System1.ResourceMonitor do
  @moduledoc """
  Monitors resource allocation and usage in System 1.
  """
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    {:ok, %{resources: %{}}}
  end
end