defmodule VsmTelemetryWeb.CoreComponents do
  @moduledoc """
  Core UI components for VSM Telemetry.
  """
  use Phoenix.Component

  @doc """
  Renders a metric card.
  """
  attr :title, :string, required: true
  attr :value, :any, required: true
  attr :unit, :string, default: ""
  attr :class, :string, default: ""

  def metric_card(assigns) do
    ~H"""
    <div class={"bg-white rounded-lg shadow p-4 #{@class}"}>
      <h3 class="text-sm font-medium text-gray-500 mb-1"><%= @title %></h3>
      <p class="text-2xl font-bold">
        <%= @value %><span class="text-sm font-normal text-gray-500"><%= @unit %></span>
      </p>
    </div>
    """
  end

  @doc """
  Renders a progress bar.
  """
  attr :value, :integer, required: true
  attr :max, :integer, default: 100
  attr :class, :string, default: ""

  def progress_bar(assigns) do
    ~H"""
    <div class={"w-full bg-gray-200 rounded-full h-2.5 #{@class}"}>
      <div
        class="bg-blue-600 h-2.5 rounded-full"
        style={"width: #{@value/@max * 100}%"}
      >
      </div>
    </div>
    """
  end

  @doc """
  Renders flash notices.
  """
  attr :flash, :map, required: true

  def flash_group(assigns) do
    ~H"""
    <div class="fixed top-0 right-0 p-6 z-50">
      <.flash kind={:info} title="Info" flash={@flash} />
      <.flash kind={:error} title="Error" flash={@flash} />
    </div>
    """
  end

  attr :id, :string, doc: "the optional id of flash container"
  attr :flash, :map, default: %{}, doc: "the map of flash messages to display"
  attr :title, :string, default: nil
  attr :kind, :atom, values: [:info, :error], doc: "used for styling"

  def flash(assigns) do
    assigns = assign_new(assigns, :id, fn -> "flash-#{assigns.kind}" end)

    ~H"""
    <div
      :if={msg = Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      phx-click="lv:clear-flash"
      phx-value-key={@kind}
      role="alert"
      class={[
        "fixed top-2 right-2 mr-2 w-80 sm:w-96 z-50 rounded-lg p-3 ring-1",
        @kind == :info && "bg-emerald-50 text-emerald-800 ring-emerald-500 fill-cyan-900",
        @kind == :error && "bg-rose-50 text-rose-900 ring-rose-500 fill-rose-900"
      ]}
    >
      <p :if={@title} class="flex items-center gap-1.5 text-sm font-semibold leading-6">
        <span :if={@kind == :info}>✓</span>
        <span :if={@kind == :error}>✗</span>
        <%= @title %>
      </p>
      <p class="mt-2 text-sm leading-5"><%= msg %></p>
    </div>
    """
  end

  # Removed unused alias
end