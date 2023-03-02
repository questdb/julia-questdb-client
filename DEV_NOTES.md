# Dev Notes

# Pre-requisites

* Install Julia from https://www.julialang.org/downloads/
* Install Rust from https://www.rust-lang.org/tools/install

# Checking out the code and update the C client

```shell
$ git clone https://github.com/questdb/julia-questdb-client.git julia-questdb-client
$ cd julia-questdb-client
$ julia Make.jl sync_submodule
```

# Update c_questdb_client_jll

To update the c_questdb_client_jll library, the first step is to submit a pull request (PR) to the YggDrasil repository (https://github.com/JuliaPackaging/Yggdrasil/#updating-the-version-of-an-existing-builder). This will trigger the build_tarballs.jl file, which will clone the c_questdb_client and use Rust to create a release for all supported platforms. This ensures that each user downloads the appropriate package for their operating system.

Submitting a PR to Yggdrasil is an important step in the update process because it allows the package to be built and released in a consistent and automated manner. This helps to ensure that the package is reliable and compatible with a wide range of systems. It also simplifies the process of updating the library for users, as they can simply download the latest version of the package for their platform without having to worry about compatibility issues or manually building the package from source.


# Update internal LibQuestDB.jl 

When updating the c_questdb_client_jll library, it's important to ensure that the functions in LibQuestDB.jl are up-to-date. This file is auto-generated using Clang.Generators and can be found in the /gen directory, along with the generator.toml file needed to run the code. Note that some modifications may be required for the generator to work properly.

If the C library includes a breaking change, it's important to translate it into LibQuestDB.jl and QuestDB.jl, both of which can be found in the /src directory. This ensures that the Julia code remains compatible with the updated C library and that users can continue to use the package without any issues.

To update the LibQuestDB.jl file, run the following command:

```shell
$ julia --project=.
$ include("gen/generate.jl")
```

Remember the generated code is not including the exports, and some other functions that are not part of the C library. So, it's important to check the generated code and add the missing parts.

# QuestDB.jl in development mode

For start using the package, you need to start a julia session or to run the code from your terminal direcly. 

```
$ julia --project=.
```

Once you start the session you need to include the QuestDB.jl package manually.

```
$ include("/src/QuestDB.jl")
```

Then you can start iterating by using the example included in the examples directory and running the following line.


```
$ include("/src/sender_example.jl")
```

Make sure to have running a QuestDB instance in your local machine. You can download the latest version from https://questdb.io/download.

# Testing QuestDB.jl

To test the QuestDB package, we used the mock server from the Python version and adapted it for this project. Running the tests is simple - just enter the following command:

```
$ include("test/runtests.jl")
```

The tests also run during the CI process, which is triggered by a pull request to the main branch. This ensures that the package is compatible with the latest version of the C library and that any breaking changes are detected before they are merged into the main branch.





