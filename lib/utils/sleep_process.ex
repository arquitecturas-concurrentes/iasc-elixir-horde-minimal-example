defmodule IascElixirHordeMinimalExample.SleepProcess do
  @moduledoc """
  Module which generates only a random number.
  """
  use GenServer
  require Logger

  alias IascElixirHordeMinimalExample.{HordeRegistry}

  def child_spec(id, seconds_to_sleep) do
    %{
      id: id,
      start: {__MODULE__, :start_link, [id, seconds_to_sleep]},
      restart: :transient,
    }
  end

  def start_link(identifier, seconds_to_sleep) do
    Horde.Registry.register(HordeRegistry, identifier, nil)
    GenServer.start_link(__MODULE__, {identifier, seconds_to_sleep}, name: String.to_atom("sleepp#{identifier}"))
  end

  @impl GenServer
  def init({id, timeout}) do
    Logger.info("scheduling for #{timeout}ms")

    Process.send_after(self(), :execute, timeout)

    {:ok, {id, timeout}}
  end

  @impl GenServer
  def handle_info(:execute, {id, timeout}) do
    execute(timeout)
    {:noreply, {id, timeout}}
  end

  @impl GenServer
  def handle_info(:terminate, {id, timeout}) do
    Logger.info("process #{id} Finishing.")
    {:stop, :normal, {id, timeout}}
  end

  defp execute(seconds_to_sleep) do
    random = :rand.uniform(10_000)

    Logger.info("#{__MODULE__} #{inspect(self())} - Starting to sleep.")

    Process.sleep(seconds_to_sleep * 1000)
  
    Logger.info("#{__MODULE__} #{inspect(self())} - Generating Random number ->> #{random}.")

    Process.send_after(self(), :terminate, seconds_to_sleep)
  end

  # def whereis(name \\ PongWorker) do
  #   name
  #   |> via_tuple()
  #   |> GenServer.whereis()
  # end

  # def via_tuple(name) do
  #   {:via, Horde.Registry, {HordeRegistry, name}}
  # end
end