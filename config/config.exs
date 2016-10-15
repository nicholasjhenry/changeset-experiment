# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :directory,
  ecto_repos: [Directory.Repo]

# Configures the endpoint
config :directory, Directory.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Io4QXvOWSfQqB9VOv4yjC2Rm1Q5xfjYBVauj+/jMLEzYH8mYs5VYpdahoczgJBzY",
  render_errors: [view: Directory.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Directory.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
