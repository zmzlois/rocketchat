defmodule Rocketchat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RocketchatWeb.Telemetry,
      Rocketchat.Repo,
      {DNSCluster, query: Application.get_env(:rocketchat, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Rocketchat.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Rocketchat.Finch},
      # Start a worker by calling: Rocketchat.Worker.start_link(arg)
      # {Rocketchat.Worker, arg},
      # Start to serve requests, typically the last entry
      RocketchatWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Rocketchat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RocketchatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
