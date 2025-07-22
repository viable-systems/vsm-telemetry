defmodule VsmTelemetry.MixProject do
  use Mix.Project

  def project do
    [
      app: :vsm_telemetry,
      version: "0.1.0",
      elixir: "~> 1.17",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  def application do
    [
      mod: {VsmTelemetry.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  defp deps do
    [
      # Phoenix and LiveView
      {:phoenix, "~> 1.7.0"},
      {:phoenix_html, "~> 4.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.20.0"},
      {:phoenix_live_dashboard, "~> 0.8.0"},
      
      # Telemetry and Metrics
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.1"},
      {:prometheus_ex, "~> 3.1"},
      {:prometheus_plugs, "~> 1.1"},
      
      # Web server
      {:plug_cowboy, "~> 2.5"},
      {:jason, "~> 1.2"},
      
      # Development tools
      {:floki, ">= 0.30.0", only: :test},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2", runtime: Mix.env() == :dev}
    ] ++ vsm_deps()
  end
  
  defp vsm_deps do
    if in_umbrella?() do
      # In umbrella mode, dependencies are managed by the umbrella project
      []
    else
      [
        {:vsm_core, path: "../vsm-core"}
      ]
    end
  end
  
  defp in_umbrella? do
    Mix.Project.umbrella?()
  end

  # Aliases are shortcuts or tasks specific to the current project.
  defp aliases do
    [
      setup: ["deps.get", "assets.setup", "assets.build"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind vsm_telemetry", "esbuild vsm_telemetry"],
      "assets.deploy": [
        "tailwind vsm_telemetry --minify",
        "esbuild vsm_telemetry --minify",
        "phx.digest"
      ]
    ]
  end
end