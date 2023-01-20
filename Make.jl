using Pkg
Pkg.add("ArgParse", io=devnull)

using ArgParse

s = ArgParseSettings()

@add_arg_table s begin
    "command"
        required = true
        arg_type = String
        help = "Make command to run. E.g. build, clean, etc."
end


questdb_rs_ffi_dir = joinpath(@__DIR__, "c-questdb-client", "questdb-rs-ffi")


function build()
    cargo_build = Cmd(
        `cargo build --release`,
        dir = questdb_rs_ffi_dir)
    run(cargo_build)

    target_dir = joinpath(questdb_rs_ffi_dir, "target", "release")
    name = "questdb_client"

    ## TODO: There needs to be some OS-specific logic here to copy the
    ##       correct library file to the correct location.
    lib_prefix = "lib"  # TODO needs to be "" on Windows.
    lib_suffix = ".so"  # Needs to be ".dll" on Windows; ".dylib" on Mac.
    lib_name = lib_prefix * name * lib_suffix
    lib_path = joinpath(target_dir, lib_name)

    # Copy the lib to its final destination.
    # TODO this is pure conjecture that that's where it ought to land.
    cp(lib_path, joinpath(@__DIR__, "src", lib_name))
end


function clean()
    cargo_clean = Cmd(
        `cargo clean`,
        dir = questdb_rs_ffi_dir)
    run(cargo_clean)
end


function sync_submodule()
    git_submodule_update = Cmd(
        `git submodule update --init --recursive`,
        dir = @__DIR__)
    run(git_submodule_update)
end


function main()
    parsed_args = parse_args(ARGS, s)

    command = parsed_args["command"]

    if command == "build"
        build()

    elseif command == "clean"
        clean()

    elseif command == "sync_submodule"
        sync_submodule()

    else
        println("Unknown command: $command")

    end
end

main()
