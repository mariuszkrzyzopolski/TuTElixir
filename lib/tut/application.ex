defmodule Tut.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TutWeb.Telemetry,
      Tut.Repo,
      {DNSCluster, query: Application.get_env(:tut, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Tut.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Tut.Finch},
      # Start a worker by calling: Tut.Worker.start_link(arg)
      # {Tut.Worker, arg},
      # Start to serve requests, typically the last entry
      TutWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tut.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TutWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
