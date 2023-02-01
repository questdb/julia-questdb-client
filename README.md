# julia-questdb-client
Julia QuestDB client


# Run example [dev mode]

1. start julia: ``julia --project=.```
2. run include("src/QuestDB.jl")
3. run include("examples/sender_example.jl")

# WIP
1. Implement timestamp column
2. Implement TLS/CA
3. Start with CI configs for release 
    - Create PR to JLL's repository with build_tarballs.jl so the JLL's for each platform will be automatically generated.
    - Create final package to be added as Pkg.add("QuestDB")