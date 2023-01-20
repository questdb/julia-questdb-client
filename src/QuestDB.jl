module QuestDB

using Libdl

# Probably some OS name detection here with the prefix/suffix (See Make.jl)
const libquestdb = Libdl.find_library(["questdb_client", "questdb"])

# A "Buffer" struct.
# Core API:
#     table, symbol, column_bool, column_i64, column_f64, column_str, at, at_now
# Additional API
#     size, reserve, clear
# This will create a buffer object, hold a pointer to it and clean it up
# when the object is garbage collected.
# It will then forward to the various C APIs.

# A "Sender" struct.
# This will probably need a builder like the Rust one.
#    https://docs.rs/questdb-rs/latest/questdb/ingress/struct.SenderBuilder.html
# Core API:
#    flush
#    flush_and_keep
# 
# Again, this will also hold a pointer to the C object and clean it up at gc.

end # module
