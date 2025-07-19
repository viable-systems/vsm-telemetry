defmodule VsmTelemetry.VarietyCalculatorTest do
  use ExUnit.Case
  alias VsmTelemetry.VarietyCalculator
  
  setup do
    {:ok, pid} = VarietyCalculator.start_link()
    {:ok, calculator: pid}
  end
  
  describe "variety calculations" do
    test "calculates Shannon entropy correctly" do
      # Test with uniform distribution (maximum entropy)
      states = [:a, :b, :c, :d]
      {:ok, variety} = VarietyCalculator.calculate_variety(:test_system, states)
      assert_in_delta variety, 2.0, 0.01  # log2(4) = 2
      
      # Test with single state (minimum entropy)
      states = [:a, :a, :a, :a]
      {:ok, variety} = VarietyCalculator.calculate_variety(:test_system, states)
      assert variety == 0.0
      
      # Test with mixed distribution
      states = [:a, :a, :b, :b, :b, :c]
      {:ok, variety} = VarietyCalculator.calculate_variety(:test_system, states)
      assert variety > 0 and variety < 2.0
    end
    
    test "calculates requisite variety ratio" do
      controller_states = [:control1, :control2, :control3, :control4]
      controlled_states = [:state1, :state2]
      
      {:ok, result} = VarietyCalculator.calculate_requisite_variety(
        controller_states,
        controlled_states
      )
      
      assert result.controller_variety == 2.0  # log2(4)
      assert result.controlled_variety == 1.0   # log2(2)
      assert result.ratio == 2.0
      assert result.sufficient == true
    end
    
    test "handles insufficient variety" do
      controller_states = [:control1, :control1]  # Low variety
      controlled_states = [:state1, :state2, :state3, :state4]  # High variety
      
      {:ok, result} = VarietyCalculator.calculate_requisite_variety(
        controller_states,
        controlled_states
      )
      
      assert result.ratio < 1.0
      assert result.sufficient == false
    end
  end
end