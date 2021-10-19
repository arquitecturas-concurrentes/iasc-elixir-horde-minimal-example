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

### How to send message to the supervised processes by horde??

At some point you’re going to start multiple processes under a distributed supervisor, and you’ll want to communicate with them. The question is: how? 

With a normal application, you would name your processes (which is called “registering” them), and then refer to them by that name.

For the example we have on this minimal example it'd be something like:

```elixir
GenServer.call(IascElixirHordeMinimalExample.PongWorker, :ping)
```

But this mechanism is scoped to a single node. If you know where a process is running, then you can just pass the node where this process is currently in an extra argument:

```elixir
GenServer.call({IascElixirHordeMinimalExample.PongWorker, node}, :ping)
```

But the main issue lies on that we need to know where Horde is going to spawn our `PongWorker` process, also, Horde starts the new process on a random node, o how can you know which node your process is running on to address it with `{name, node}`? The answer is: we need to use `Horde.Registry`.

`Horde.Registry` is a distributed process registry. That means that you can register a process with it, and then access that process from any location in your cluster.

There are a couple of ways you can do this. 

For example, you can call `Horde.Registry.register(registry, :foo)` from within a process (eg, the init/1 callback of a GenServer) to register it. The pid of this process can then be found by calling 

```elixir
Horde.Registry.lookup(registry, :foo)
```

from any node in the cluster. This will work, but there is a nicer approach. We just can use the `via_tuple` in order to get a tuple that will be used to know exactly the process is found and then just call it, once we have its id, it's going to be as calling a process on the cluster. 

```elixir
tuple = IascElixirHordeMinimalExample.PongWorker.Starter.via_tuple(PongWorker)
# {:via, Horde.Registry, {IascElixirHordeMinimalExample.HordeRegistry, PongWorker}}
pid = GenServer.whereis(tuple)
GenServer.call(pid, :ping)
```

#### OTP and Horde

One of the best things about Horde is that its Supervisor and Registry both function as OTP building blocks in a way you’re familiar with. This means that common OTP patterns can be utilized with Horde to build distributed supervision trees of arbitrary complexity combined with distributed registries. I’ve included a supervision tree diagram here for illustration.

![](/img/diagram.jpg)

Horde.Supervisor and Horde.Registry are just two new tools in your OTP toolbox.

