defmodule IascElixirHordeMinimalExample.SleepTask do
  @moduledoc """
  Module which generates only a random number.
  """
  require Logger

  alias IascElixirHordeMinimalExample.{HordeRegistry}

  def start_execution(identifier, seconds_to_sleep) do
    Horde.Registry.register(HordeRegistry, identifier, nil)
    random = :rand.uniform(10_000)

    Process.sleep(seconds_to_sleep * 1000)
  
    Logger.info("#{__MODULE__} - Generating Random number ->> #{random}.")

    Logger.info("process #{identifier} finished after #{seconds_to_sleep}s")
  end
end