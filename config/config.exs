# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# ----------------------------------------------------------------- #
# AWS Config
# ----------------------------------------------------------------- #
config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role]

# ----------------------------------------------------------------- #
# Project Config
# ----------------------------------------------------------------- #
config :rh,
  namespace: RH,
  ecto_repos: [RH.Repo]

# Configures the endpoint
config :rh, RHWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "93KdumR2Cv8zLyyEL2PbDm0DNhx3cuTDHoNfDQN2maoC736GYOCLPGuNUN8TOvIw",
  render_errors: [view: RHWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: RH.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Tesla HTTP Client config
config :tesla, adapter: Tesla.Adapter.Hackney

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
