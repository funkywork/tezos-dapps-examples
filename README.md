# tezos-dapps-examples

A collection of samples of Tezos dApps built on top of Nightmare and Yourbones

## Setting up the development environment

Setting up a development environment is quite common. We recommend setting up a
local switch to collect dependencies locally. Here are the commands to enter to
initiate the environment:

```shell
opam update
opam switch create . ocaml-base-compiler.5.0.0 --deps-only -y
eval $(opam env)
```

After initializing the switch, you can collect the development and project
dependencies using `make`:

```shell
make deps
```

> **Note** If you are not using [GNU/Make](https://www.gnu.org/software/make/)
> (or equivalent), you can refer to the [Makefile](Makefile) and observe the
> `dev-deps` and `deps` rules to get the commands to run.
