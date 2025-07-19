defmodule VsmTelemetry.Metrics do
  @moduledoc """
  VSM-specific metrics definitions and setup.
  """
  
  def setup do
    # Register custom metric types if needed
    setup_histograms()
    setup_counters()
    setup_summaries()
  end
  
  defp setup_histograms do
    # Response time histograms
    :prometheus_histogram.new([
      name: [:vsm, :response_time],
      labels: [:system, :operation],
      buckets: [10, 50, 100, 250, 500, 1000, 2500, 5000, 10000],
      help: "Response time for VSM operations in milliseconds"
    ])
    
    # Processing time histograms
    :prometheus_histogram.new([
      name: [:vsm, :processing_time],
      labels: [:system, :task_type],
      buckets: [5, 10, 25, 50, 100, 250, 500, 1000],
      help: "Processing time for VSM tasks in milliseconds"
    ])
  end
  
  defp setup_counters do
    # Operation counters
    :prometheus_counter.new([
      name: [:vsm, :operations_total],
      labels: [:system, :operation, :status],
      help: "Total number of VSM operations"
    ])
    
    # Error counters
    :prometheus_counter.new([
      name: [:vsm, :errors_total],
      labels: [:system, :error_type],
      help: "Total number of errors in VSM"
    ])
    
    # Message counters
    :prometheus_counter.new([
      name: [:vsm, :messages_total],
      labels: [:from_system, :to_system, :message_type],
      help: "Total number of messages between VSM systems"
    ])
  end
  
  defp setup_summaries do
    # Variety summaries
    :prometheus_summary.new([
      name: [:vsm, :variety_absorbed],
      labels: [:system],
      help: "Amount of variety absorbed by each system"
    ])
    
    # Coordination summaries
    :prometheus_summary.new([
      name: [:vsm, :coordination_lag],
      labels: [:between_systems],
      help: "Coordination lag between VSM systems"
    ])
  end
  
  # Helper functions for recording metrics
  def record_operation(system, operation, status, duration) do
    :prometheus_counter.inc(
      [:vsm, :operations_total],
      [system, operation, status]
    )
    
    :prometheus_histogram.observe(
      [:vsm, :response_time],
      [system, operation],
      duration
    )
  end
  
  def record_error(system, error_type) do
    :prometheus_counter.inc(
      [:vsm, :errors_total],
      [system, error_type]
    )
  end
  
  def record_message(from_system, to_system, message_type) do
    :prometheus_counter.inc(
      [:vsm, :messages_total],
      [from_system, to_system, message_type]
    )
  end
  
  def record_variety_absorbed(system, amount) do
    :prometheus_summary.observe(
      [:vsm, :variety_absorbed],
      [system],
      amount
    )
  end
  
  def record_coordination_lag(between_systems, lag) do
    :prometheus_summary.observe(
      [:vsm, :coordination_lag],
      [between_systems],
      lag
    )
  end
end