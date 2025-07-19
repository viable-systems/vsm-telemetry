# VSM Telemetry

A comprehensive telemetry and monitoring system for Viable System Model (VSM) implementations, built with Elixir/Phoenix and Prometheus.

## Features

- Real-time monitoring of all 5 VSM subsystems
- Prometheus metrics export at `/metrics`
- Live dashboard with Phoenix LiveView
- Comprehensive metric collection including:
  - System 1 (Operations): Performance, resource utilization, throughput
  - System 2 (Coordination): Efficiency, variety handling, channel capacity
  - System 3 (Control): Effectiveness, optimization, audit compliance
  - System 4 (Intelligence): Environmental awareness, future readiness
  - System 5 (Policy): Coherence, identity, strategic alignment
- Overall viability metrics: viability index, recursion depth, autonomy level

## Setup

1. Install dependencies:
```bash
mix deps.get
```

2. Install Node.js dependencies (for assets):
```bash
cd assets && npm install
```

3. Start the Phoenix server:
```bash
mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Endpoints

- `/` - Main VSM dashboard
- `/metrics` - Prometheus metrics endpoint
- `/dev/dashboard` - Phoenix LiveDashboard (dev mode only)

## Architecture

The system is organized into:

- **VSM Subsystems** (lib/vsm_telemetry/system1-5/): Each subsystem has its own supervisor and monitoring processes
- **Metrics Collection** (lib/vsm_telemetry/metrics_collector.ex): Central collector that aggregates metrics
- **Prometheus Export** (lib/vsm_telemetry/prometheus_exporter.ex): Exposes metrics in Prometheus format
- **Web Interface** (lib/vsm_telemetry_web/): Phoenix LiveView dashboard

## Configuration

Edit `config/config.exs` for general configuration and `config/dev.exs` for development-specific settings.

## Production Deployment

For production deployment:

1. Set environment variables:
   - `SECRET_KEY_BASE` - Generate with `mix phx.gen.secret`
   - `PHX_HOST` - Your domain name
   - `PORT` - Port to bind to

2. Build release:
```bash
MIX_ENV=prod mix release
```

3. Run the release:
```bash
PHX_SERVER=true _build/prod/rel/vsm_telemetry/bin/vsm_telemetry start
```