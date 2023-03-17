
# QuestDB client for Julia

This package provides a Julia client for [QuestDB](https://questdb.io/), a high-performance time-series database.

# Installation

The package can be installed using the Julia package manager:

```julia
julia> "]"
pkg> add QuestDB
```
```

or 

```julia
using Pkg
Pkg.add("QuestDB")
```

# Usage

The package provides a high-level API for interacting with QuestDB. The API is designed to be as simple as possible, while still providing the functionality required to work with time-series data. The package also provides a low-level API for interacting with the C library directly.

## Examples

The following examples show how to use the package to interact with QuestDB. For more examples, see the [examples](examples) directory.

```julia

using .QuestDB
using Dates

auth = (
    "testUser1",                                    # kid
    "5UjEMuA0Pj5pjK8a-fa24dyIf-Es5mYny3oE_Wmus48",  # d
    "fLKYEaoEb9lrn3nkwLDA-M_xnuFOdSt9y0Z7_vWSHLU",  # x
    "Dt5tbS1dEDMSYfym3fgMv0B99szno-dFc1rYF9t0aac"   # y
)  

sender = Sender("localhost", 9009, auth)

try                      
    sender.table("testing_OOP2")
    sender.symbol("first_symbol", "first_symbol")
    sender.column("column_a", "value_a")
    sender.column("column_b_int", 1)
    sender.column("column_c_float", 1.1)
    sender.column("column_d_bool", true)
    sender.column("timestamp_column", Dates.Microsecond(1674983677000000))            
    sender.flush()
catch e
    println(e)
finally
    sender.close()
end
```

# Docs

The documentation for the package can be found [here](https://questdb.github.io/QuestDB.jl). The documentation is automatically generated using Documenter.jl.

# Community

If you need help, have additional questions or want to provide feedback, you may find us on Slack.

You can also sign up to our mailing list to get notified of new releases.

# License
The code is released under the Apache License 2.0.