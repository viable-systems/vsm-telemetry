defmodule VsmTelemetry.MetricsTest do
  use ExUnit.Case
  alias VsmTelemetry.Metrics
  
  describe "metrics recording" do
    test "records operations correctly" do
      # Record a successful operation
      assert :ok = Metrics.record_operation(:system1, :process_data, :success, 150)
      
      # Record a failed operation
      assert :ok = Metrics.record_operation(:system2, :coordinate, :failure, 500)
    end
    
    test "records errors" do
      assert :ok = Metrics.record_error(:system3, :timeout)
      assert :ok = Metrics.record_error(:system4, :connection_failed)
    end
    
    test "records messages between systems" do
      assert :ok = Metrics.record_message(:system1, :system2, :coordination)
      assert :ok = Metrics.record_message(:system3, :system4, :intelligence_update)
    end
    
    test "records variety absorption" do
      assert :ok = Metrics.record_variety_absorbed(:system1, 3.5)
      assert :ok = Metrics.record_variety_absorbed(:system2, 2.8)
    end
    
    test "records coordination lag" do
      assert :ok = Metrics.record_coordination_lag("system1-system2", 45)
      assert :ok = Metrics.record_coordination_lag("system3-system4", 120)
    end
  end
end