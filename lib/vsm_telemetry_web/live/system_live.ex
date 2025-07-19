defmodule VsmTelemetryWeb.SystemLive do
  use VsmTelemetryWeb, :live_view

  @impl true
  def mount(%{"id" => system_id}, _session, socket) do
    {:ok, assign(socket, system_id: system_id, metrics: %{})}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h1 class="text-3xl font-bold mb-6">System <%= @system_id %> Details</h1>
      <p>Detailed metrics and monitoring for System <%= @system_id %></p>
    </div>
    """
  end
end