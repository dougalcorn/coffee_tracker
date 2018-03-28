# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :coffee_tracker,
  ecto_repos: [CoffeeTracker.Repo]

# Configures the endpoint
config :coffee_tracker, CoffeeTrackerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "J9ufiwC+YmnlruGmr/j41pRcppGdp1zHotHzQKZVeHUT8sXuLrF0e4uNBavSE5fX",
  render_errors: [view: CoffeeTrackerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CoffeeTracker.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :coffee_tracker, CoffeeTracker.Auth.Guardian,
  issuer: "coffee_tracker", # Name of your app/company/product
  secret_key: "" # Replace this with the output of the mix command

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
