defmodule RelaxedProcessesSpawner do
  @doc """
  Module for generating workers that will be using the HordeSupervisor and Registry
  """
  use GenServer
  require Logger

  alias CustomIASC.{HordeSupervisor}
  alias IascElixirHordeMinimalExample.{SleepProcess}

  @doc """

  """
  def perform(number, seconds_to_live) do
    start_link({number, seconds_to_live})
  end

  def start_link({number, seconds_to_live}) do
    GenServer.start_link(__MODULE__, {number, seconds_to_live})
  end

  def init({number, seconds_to_live}) do
    {:ok, {number, seconds_to_live}, {:continue, :start_processes}}
  end

  @doc """
  handle_continue :start_processes to be called only when the number status has reached 0. Stop this process normally.
  """
  def handle_continue(:start_processes, {0, _}) do
    Logger.info("Shutting down this stress test process #{inspect(self())}.")
    {:stop, :normal, nil}
  end

  def handle_continue(:start_processes, {number, seconds_to_live}) do
    child_spec = SleepProcess.child_spec(number, seconds_with_jitter(seconds_to_live))
    HordeSupervisor.start_child(child_spec)

    Logger.info("started process #{number}")

    {:noreply, {number - 1, seconds_to_live}, {:continue, :start_processes}}
  end

  defp seconds_with_jitter(seconds_to_live) do
    (seconds_to_live * 0.55 + :rand.uniform(seconds_to_live) / 2)
    |> round()
  end
end

# RelaxedProcessesSpawner.perform(20,2)