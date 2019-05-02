defmodule RTL.Mixfile do
  use Mix.Project

  def project do
    [
      app: :rtl,
      version: "0.0.1",
      elixir: "~> 1.8.1",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {RTL, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_), do: ["lib", "web"]

  # Specifies your project dependencies.
  # Type `mix help deps` for examples and options.
  # Mix auto-starts all relevant `deps` as applications.
  defp deps do
    [
      # Core
      {:phoenix, "~> 1.4.3"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 3.6"},
      {:phoenix_html, "~> 2.13"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:plug_cowboy, "~> 2.0"},
      {:postgrex, "~> 0.13"},
      {:gettext, "~> 0.16"},
      {:jason, "~> 1.1"},
      {:rollbax, "~> 0.10"},
      {:phoenix_live_view, github: "phoenixframework/phoenix_live_view"},
      {:html_sanitize_ex, "~> 1.3"},

      # Auth
      {:ueberauth, "~> 0.6"},
      {:ueberauth_auth0, "~> 0.3"},

      # Logic
      {:csv, "~> 2.2"},
      {:timex, "~> 3.5"},
      # Incompatible w Ecto v3. I'll have to relearn how to do datetimes in Ecto.
      {:timex_ecto, "~> 3.3"},

      # File storage & HTTP requests
      # file uploads
      {:arc, "~> 0.11"},
      # :arc S3 integration
      # Downgraded to avoid presigned url bug: https://github.com/ex-aws/ex_aws/issues/602
      {:ex_aws, "2.0.1"},
      # :arc S3 integration
      {:ex_aws_s3, "~> 2.0"},
      # for fetching S3 files in tests
      {:httpotion, "~> 3.1"},
      # required by :ex_aws
      {:sweet_xml, "~> 0.6"},

      # Email
      # not currently in use, but will be soon
      {:bamboo, "~> 1.2"},
      {:bamboo_smtp, "~> 1.6"},

      # Tests
      {:hound, "~> 1.0", only: :test},
      {:logger_file_backend, "~> 0.0", only: :test}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  defp aliases do
    [
      test: [
        "ecto.create --quiet",
        "ecto.migrate",
        "run priv/clear_test_log.exs",
        "test"
      ],
      list_autologins: ["run priv/repo/list_autologins.exs"]
    ]
  end
end
