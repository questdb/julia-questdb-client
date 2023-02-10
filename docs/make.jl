# see documentation at https://juliadocs.github.io/Documenter.jl/stable/
push!(LOAD_PATH, "../src/")
using Documenter, .QuestDB, .LibQuestDB

makedocs(
    modules = [QuestDB, LibQuestDB],
    format = Documenter.HTML(; prettyurls = get(ENV, "CI", nothing) == "true"),
    authors = "Brandon Escamilla",
    sitename = "QuestDB.jl",
    pages = Any[        
        "Home" => "index.md",
        "Installation" => "installation.md",
        "API Reference" => "api-reference.md",
        "Examples" => "examples.md",
        "Contributing" => "contributing.md",
        "Troubleshooting" => "troubleshooting.md",
        "Changelog" => "changelog.md"    
    ]
    # strict = true,
    # clean = true,
    # checkdocs = :exports,
)

# Some setup is needed for documentation deployment, see “Hosting Documentation” and
# deploydocs() in the Documenter manual for more information.
deploydocs(
    repo = "github.com/questdb/julia-questdb-client.git",
    push_preview = true
)
