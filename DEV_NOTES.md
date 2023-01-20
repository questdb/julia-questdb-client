# Dev Notes

# Pre-requisites

* Install Julia from https://www.julialang.org/downloads/
* Install Rust from https://www.rust-lang.org/tools/install

# Checking out the code

```shell
$ git clone https://github.com/questdb/julia-questdb-client.git julia-questdb-client
$ cd julia-questdb-client
$ julia make sync_submodule
```

# Building the Rust code and copying the dynamic lib

```shell
$ julia make build
```
