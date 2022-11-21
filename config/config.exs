import Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# if config_env() == :dev do
  config :liesne_bot, :version, "v0_0_2"
# end