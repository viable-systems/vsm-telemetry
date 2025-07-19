defmodule VsmTelemetryWeb.PrometheusExporter do
  @moduledoc """
  Plug for exposing Prometheus metrics at /metrics endpoint
  """
  use Plug.Builder

  plug :export_metrics

  def export_metrics(conn, _opts) do
    metrics = :prometheus_text_format.format()
    
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, metrics)
    |> halt()
  end
end