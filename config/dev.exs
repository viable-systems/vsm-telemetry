import Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we can use it
# to bundle .js and .css sources.
config :vsm_telemetry, VsmTelemetryWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "bKPF5H1xZ3kPmNsxHd8kPmNsxHd8kPmNsxHd8kPmNsxHd8kPmNsxHd8kPmNs",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:vsm_telemetry, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:vsm_telemetry, ~w(--watch)]}
  ]

# Watch static and templates for browser reloading.
config :vsm_telemetry, VsmTelemetryWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"lib/vsm_telemetry_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

# Enable dev routes for dashboard
config :vsm_telemetry, dev_routes: true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime