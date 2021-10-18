defmodule IascElixirHordeMinimalExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Cluster.Supervisor, [topologies(), [name: BackgroundJob.ClusterSupervisor]]},
      IascElixirHordeMinimalExample.HordeRegistry,
      IascElixirHordeMinimalExample.HordeSupervisor,
      IascElixirHordeMinimalExample.NodeObserver.Supervisor,
      { IascElixirHordeMinimalExample.PongWorker.Starter,
      [name: IascElixirHordeMinimalExample.PongWorker, timeout: :timer.seconds(10)]}
      # Starts a worker by calling: IascElixirHordeMinimalExample.Worker.start_link(arg)
      # {IascElixirHordeMinimalExample.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: IascElixirHordeMinimalExample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp topologies do
    [
      background_job: [
        strategy: Cluster.Strategy.Gossip
      ]
    ]
  end
end
