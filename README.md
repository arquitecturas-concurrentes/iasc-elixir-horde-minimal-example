# IascElixirHordeMinimalExample

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `iasc_elixir_horde_minimal_example` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:iasc_elixir_horde_minimal_example, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/iasc_elixir_horde_minimal_example>.

## How to start it?

Just run the following command:

```bash
iex -sname node1 --cookie some_cookie -S mix
```

this will start the cluster, with just one cluster member, if you want to add more nodes, just add them with a sname, and using the same cookie you set to the first node, otherwise, the nodes won't be able to connect each other.

#### Stress tests

We have a small utility process, to spawn tasks to just do some random processing and then just make these process to die and terminate eventually. This is done by the `StressTest` process, that we can call using `perform/2`. This function will spawn `n` processes with `m` ttl. The startegy that these spawned processes are distributed, is mainly based on the HordeSupervisor strategy.

an example that will spawn 20 `SleepTask` with 20 seconds of ttl is with the following command on an iex in the cluster.

```elixir
StressTest.perform(20, 20)
```