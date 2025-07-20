defmodule VsmTelemetryWeb.PrometheusExporter do
  @moduledoc """
  Plug for exposing Prometheus metrics at /metrics endpoint
  """
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    path = opts[:path] || "/metrics"
    
    if conn.request_path == path do
      metrics = :prometheus_text_format.format()
      
      conn
      |> put_resp_content_type("text/plain")
      |> send_resp(200, metrics)
      |> halt()
    else
      conn
    end
  end
end