defmodule IascElixirHordeMinimalExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Cluster.Supervisor, [topologies(), [name: MinimalExample.ClusterSupervisor]]},
      CustomIASC.HordeRegistry,
      # https://hexdocs.pm/horde/Horde.UniformQuorumDistribution.html
      {CustomIASC.HordeSupervisor, [strategy: :one_for_one, distribution_strategy: Horde.UniformQuorumDistribution, process_redistribution: :active]},
      CustomIASC.NodeObserver.Supervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html for other strategies and supported options
    opts = [strategy: :one_for_one, name: IascElixirHordeMinimalExample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp topologies do
    [
      horde_minimal_example: [
        strategy: Cluster.Strategy.Gossip
      ]
    ]
  end
end
