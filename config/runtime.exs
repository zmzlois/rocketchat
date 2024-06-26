import Config
import Dotenvy

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# Load environment variables from `.env` file in runtime.
source!([".env", System.get_env()])

# ## Using releases
#
# If you use `mix release`, you need to explicitly enable the server
# by passing the PHX_SERVER=true when you start it:
#
#     PHX_SERVER=true bin/rocketchat start
#
# Alternatively, you can use `mix phx.gen.release` to generate a `bin/server`
# script that automatically sets the env var above.
if env!("PHX_SERVER", :boolean, false) do
  config :rocketchat, RocketchatWeb.Endpoint, server: true
end

defmodule Config.Runtime do
  def setup(:prod) do
    database_url = env!("DATABASE_URL")

    maybe_ipv6 = if env!("ECTO_IPV6", :boolean, false), do: [:inet6], else: []

    config :rocketchat, Rocketchat.Repo,
      # ssl: true,
      url: database_url,
      pool_size: env!("POOL_SIZE", :integer, 10),
      socket_options: maybe_ipv6

    # The secret key base is used to sign/encrypt cookies and other secrets.
    # A default value is used in config/dev.exs and config/test.exs but you
    # want to use a different value for prod and you most likely don't want
    # to check this value into version control, so we use an environment
    # variable instead.
    # You can generate one by calling: mix phx.gen.secret
    secret_key_base = env!("SECRET_KEY_BASE")

    host = env!("PHX_HOST", :string, "example.com")
    port = env!("PORT", :integer, 4000)

    config :rocketchat, :dns_cluster_query, env!("DNS_CLUSTER_QUERY", :string, nil)

    config :rocketchat, RocketchatWeb.Endpoint,
      url: [host: host, port: 443, scheme: "https"],
      http: [
        # Enable IPv6 and bind on all interfaces.
        # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
        # See the documentation on https://hexdocs.pm/bandit/Bandit.html#t:options/0
        # for details about using IPv6 vs IPv4 and loopback vs public addresses.
        ip: {0, 0, 0, 0, 0, 0, 0, 0},
        port: port
      ],
      secret_key_base: secret_key_base

    # ## SSL Support
    #
    # To get SSL working, you will need to add the `https` key
    # to your endpoint configuration:
    #
    #     config :rocketchat, RocketchatWeb.Endpoint,
    #       https: [
    #         ...,
    #         port: 443,
    #         cipher_suite: :strong,
    #         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
    #         certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
    #       ]
    #
    # The `cipher_suite` is set to `:strong` to support only the
    # latest and more secure SSL ciphers. This means old browsers
    # and clients may not be supported. You can set it to
    # `:compatible` for wider support.
    #
    # `:keyfile` and `:certfile` expect an absolute path to the key
    # and cert in disk or a relative path inside priv, for example
    # "priv/ssl/server.key". For all supported SSL configuration
    # options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
    #
    # We also recommend setting `force_ssl` in your config/prod.exs,
    # ensuring no data is ever sent via http, always redirecting to https:
    #
    #     config :rocketchat, RocketchatWeb.Endpoint,
    #       force_ssl: [hsts: true]
    #
    # Check `Plug.SSL` for all available options in `force_ssl`.

    # ## Configuring the mailer
    #
    # In production you need to configure the mailer to use a different adapter.
    # Also, you may need to configure the Swoosh API client of your choice if you
    # are not using SMTP. Here is an example of the configuration:
    #
    #     config :rocketchat, Rocketchat.Mailer,
    #       adapter: Swoosh.Adapters.Mailgun,
    #       api_key: System.get_env("MAILGUN_API_KEY"),
    #       domain: System.get_env("MAILGUN_DOMAIN")
    #
    # For this example you need include a HTTP client required by Swoosh API client.
    # Swoosh supports Hackney and Finch out of the box:
    #
    #     config :swoosh, :api_client, Swoosh.ApiClient.Hackney
    #
    # See https://hexdocs.pm/swoosh/Swoosh.html#module-installation for details.
  end

  def setup(:dev) do
    setup_local_db_connection()

    config :rocketchat,
      openai_org_id: env!("OPENAI_ORG_ID", :string),
      openai_project_id: env!("OPENAI_PROJECT_ID", :string),
      openai_secret_id: env!("OPENAI_SECRET_KEY", :string)
  end

  def setup(:test) do
  end

  def setup(_) do
    IO.inspect(config_env(),
      label: "Runtime config didn't match any environment. Current environment"
    )
  end

  defp setup_local_db_connection do
    # Configure your database
    config :rocketchat, Rocketchat.Repo,
      username: env!("DB_USER", :string, "rocketchat"),
      password: env!("DB_PASS", :string, "rocketchat"),
      hostname: env!("DB_HOST", :string, "0.0.0.0"),
      database: env!("DB_NAME", :string, "rocketchat-pg"),
      port: env!("DB_PORT", :integer!, 5432),
      stacktrace: env!("DB_LOGS", :bool, true),
      show_sensitive_data_on_connection_error: true,
      pool_size: env!("DB_POOL_SIZE", :integer!, 10)
  end
end

Config.Runtime.setup(config_env())
