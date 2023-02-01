using Clang.Generators
using c_questdb_client_jll

cd(@__DIR__)


include_dir = joinpath(c_questdb_client_jll.artifact_dir, "include") |> normpath
println(include_dir)
# wrapper generator options
options = load_options(joinpath(@__DIR__, "generator.toml"))

# add compiler flags, e.g. "-DXXXXXXXXX"
args = get_default_args()  # Note you must call this function firstly and then append your own flags
push!(args, "-I$include_dir")


#header_dir = include_dir
#headers = [joinpath(header_dir, "questdb/ilp/line_sender.h")]
headers = detect_headers(include_dir, args)

println(headers)
# create context
ctx = create_context(headers, args, options)

# run generator
build!(ctx)