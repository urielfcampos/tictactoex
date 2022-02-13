import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :tictactoex, Tictactoex.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "tictactoex_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tictactoex, TictactoexWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "eVlBkWWOWzoOqktzfbt86B1wzEpEeu4K1XMGBmPEMAYpmot2LdougOWjSxsli5rY",
  server: false

# In test we don't send emails.
config :tictactoex, Tictactoex.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
