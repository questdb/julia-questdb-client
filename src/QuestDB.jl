
module QuestDB

include("LibQuestDB.jl")

using .LibQuestDB 
using Dates

struct Table{T}
    sender::T
end

struct Column{T}
    sender::T
end

struct Symbol{T}
    sender::T
end

struct At{T}
    sender::T
end

struct AtNow{T}
    sender::T
end

struct Flush{T}
    sender::T
end

struct Close{T}
    sender::T
end

"""Sender constructor
    Creates a sender object to send data to `host` at `port`. If `tls` is `true`, the connection
    uses TLS encryption. If `auth` is provided, authentication will be attempted using the given
    `auth` credentials.

    Auto flushing is enabled automatically, the init capacity by default is 64kb.

    ## Parameters
    * `host`: Hostname to connect to.
    * `port`: Port to connect to.
    * `auth`: Authentication credentials in the form of a tuple containing `(key_id, priv_key, pub_key_x, pub_key_y)`.
    * `tls` :  Whether to use TLS encryption. Defaults to `false`.

    ## Methods 

    * `table(name::String)`            
    * `symbol(name::String, value::String)`            
    * `column(name::String, column_value::Union{String, Int, Float64, Bool, Dates.TimeType})`            
    * `at_now()`            
    * `at(timestamp::Dates.TimeType)`            
    * `flush()`
        

    ## Returns        
    Sender object that can be used to send data.
"""
mutable struct Sender        
    host_utf8::Ref{line_sender_utf8}
    port::Ref{UInt16}
    key_id_utf8::Ref{line_sender_utf8}
    priv_key_utf8::Ref{line_sender_utf8}
    pub_key_x_utf8::Ref{line_sender_utf8}
    pub_key_y_utf8::Ref{line_sender_utf8}
    buffer::Ref{line_sender_buffer}
    init_capacity::Ref{UInt32}
    opts::Ref{line_sender_opts}    
    err::Ref{Ptr{line_sender_error}}    
    sender::Ref{line_sender}
    auth::Bool
    tls::Union{Bool, String}
    read_timeout::Union{Int, Nothing}
    
    function Sender(host::String="localhost", port::Int=9009; auth=nothing, tls::Union{String, Bool}=false, read_timeout::Union{Int, Nothing}=nothing, init_capacity::Int=64*1024)
        err = Ref{Ptr{line_sender_error}}(C_NULL)
        opts = Ref{line_sender_opts}()
        sender = Ref{line_sender}()
        port = Ref{UInt16}(port)
        init_capacity = Ref{UInt32}(init_capacity)
        buffer = Ref{line_sender_buffer}()
        host_utf8 = Ref{line_sender_utf8}()        
        key_id_utf8 = Ref{line_sender_utf8}()
        priv_key_utf8 = Ref{line_sender_utf8}()
        pub_key_x_utf8 = Ref{line_sender_utf8}()
        pub_key_y_utf8 = Ref{line_sender_utf8}()
        ca_utf8 = Ref{line_sender_utf8}()

        is_host_ok = line_sender_utf8_init(host_utf8, length(host), host, err)    

        
        global buffer = line_sender_buffer_new();
        println("init_capacity: ", init_capacity[])
        line_sender_buffer_reserve(buffer, init_capacity[]);                


        if (is_host_ok)                                    
            opts = line_sender_opts_new(host_utf8[], port[])                        
                                                    
            if (tls !== false)                                
                if (tls isa Bool)
                    line_sender_opts_tls(opts);                                                                    
                elseif tls isa String
                    if (tls == "insecure_skip_verify")
                        line_sender_opts_tls_insecure_skip_verify(opts);                                            
                    elseif ispath(tls)                        
                        line_sender_utf8_init(ca_utf8, length(tls), tls, err)
                        line_sender_opts_tls_ca(opts, ca_utf8[]);                                            
                    else
                        line_sender_utf8_init(ca_utf8, length(tls), tls, err)
                        line_sender_opts_tls_ca(opts, ca_utf8[]);                        
                    end                                                                        
                else
                    throw("tls must be a bool, a path or string pointing to CA file or insecure_skip_verify")
                end
            end

            if read_timeout !== nothing
                line_sender_opts_read_timeout(opts, read_timeout)
            end

            if (auth !== nothing)
                println("Authenticating...")
                line_sender_utf8_init(key_id_utf8, length(auth[1]), auth[1], err)
                line_sender_utf8_init(priv_key_utf8, length(auth[2]), auth[2], err)
                line_sender_utf8_init(pub_key_x_utf8, length(auth[3]), auth[3], err)
                line_sender_utf8_init(pub_key_y_utf8, length(auth[4]), auth[4], err)        
                line_sender_opts_auth(opts, key_id_utf8[], priv_key_utf8[], pub_key_x_utf8[], pub_key_y_utf8[])                                    
            end        
            
            global sender = line_sender_connect(opts, err)                                                    
            line_sender_opts_free(opts)        
            
            if (sender == C_NULL)                                
                return error_handler(sender, buffer, err);           
            end            
        else            
            error_handler(sender, buffer, err);           
        end;
                    
        s = new(host_utf8, port, key_id_utf8, priv_key_utf8, pub_key_x_utf8, pub_key_y_utf8, buffer, init_capacity, opts, err, sender, auth !== nothing, tls !== false, read_timeout !== nothing)
        return s
    end
end

function Base.getproperty(s::Sender, f::Base.Symbol)    
    if f == :table        
        return Table(s)    
    elseif f == :column
        return Column(s)
    elseif f == :symbol
        return Symbol(s)
    elseif f == :at
        return At(s)
    elseif f == :at_now
        return AtNow(s)
    elseif f == :flush
        return Flush(s)
    elseif f == :close
        return Close(s)
    end

    return getfield(s, f)
end

function error_handler(sender::Ref{line_sender}, buffer::Ptr{line_sender_buffer}, err::Ref{Ptr{line_sender_error}})                
    code = line_sender_error_get_code(err[]) 
    len = Ref{Csize_t}(100)
    message = line_sender_error_msg(err[], len)    
    println(unsafe_string(message, len[]))
    
    if (code == 0)        
        error_message = "Error: Could not resolve address, Message: $(unsafe_string(message, len[]))"             
    elseif (code == 1)
        error_message = "Invalid API call, Message: $(unsafe_string(message, len[]))"
    elseif (code == 2)        
        error_message = "Socket error, Message: $(unsafe_string(message, len[]))"
    elseif (code == 3)
        error_message = "Invalid UTF8, Message: $(unsafe_string(message, len[]))"
    elseif (code == 4)
        error_message = "Invalid name, Message: $(unsafe_string(message, len[]))"
    elseif (code == 5)
        error_message = "Invalid timestamp, Message: $(unsafe_string(message, len[]))"
    elseif (code == 6)
        error_message = "Auth eror, Message: $(unsafe_string(message, len[]))"
    elseif (code == 7)
        error_message = "TLS error, Message: $(unsafe_string(message, len[]))"
    else
        error_message = "Unknown error, Message: $(unsafe_string(message, len[]))"
    end    

    line_sender_error_free(err[]);    
    line_sender_buffer_free(buffer);
    line_sender_close(sender);
    throw(ErrorException(error_message))        
end

function capacity(sender::Sender)
    return line_sender_buffer_capacity(sender.buffer)    
end


"""
    Creates a table with the given `name` in the database. The table will be created with the
    given `columns` and `types`. The `columns` and `types` must be of the same length.

    ## Parameters
    * `name`: Name of the table to create.
    * `columns`: Names of the columns in the table.
    * `types`: Types of the columns in the table.

    ## Example
    ```julia
    sender = Sender("localhost", "9000")
    sender.table("my_table", ["col1", "col2"], ["int", "string"])
    ```
"""
function(table::Table)(name::String)
    sender = table.sender
    buffer_size = line_sender_buffer_size(sender.buffer)
    buffer_capacity = capacity(sender)    
    if (buffer_size >= (buffer_capacity-1e3))        
        sender.flush()                
    end

    table_name = line_sender_table_name_assert(length(name), name);                                         
    line_sender_buffer_table(sender.buffer, table_name, sender.err);                        
    
    if (sender.err[] != C_NULL)
        error_handler(sender.sender, sender.buffer, sender.err);           
    end

    sender
end

"""
    Creates a symbol with the given `name` and `column_value` in the database. The symbol will be created with the
    given `columns` and `types`. The `columns` and `types` must be of the same length.

    ## Parameters
    * `name`: Name of the symbol to create.
    * `column_value`: Value of the column in the symbol.

    ## Example
    ```julia
    sender = Sender("localhost", "9000")
    sender.symbol("my_symbol", "my_column_value")
    ```

    ## Notes
    * The `column_value` must be a string. 
"""
function(symbol::Symbol)(name::String, column_value::String)    
    sender = symbol.sender
    col_name = line_sender_column_name_assert(length(name), name);
    column_pointer = Ref{line_sender_utf8}();
    
    line_sender_utf8_init(column_pointer, length(column_value), column_value, sender.err);                           
    line_sender_buffer_symbol(sender.buffer, col_name, column_pointer[], sender.err);

    if (sender.err[] != C_NULL)
        return error_handler(sender.sender, sender.buffer, sender.err);           
    end    
    sender
end


"""
    Creates a column with the given `name` and `column_value` in the database. The column will be created with the
    given `columns` and `types`. The `columns` and `types` must be of the same length.

    ## Parameters
    * `name`: Name of the column to create.
    * `column_value`: Value of the column.

    ## Example
    ```julia
    sender = Sender("localhost", "9000")
    sender.column("my_column", 1)
    ```

    ## Notes
    * The `column_value` must be a string, int64, float64, bool or a date. 
"""
function(column::Column)(name::String, column_value::Union{String, Int64, Float64, Bool, Dates.Microsecond})
    sender = column.sender
    col_name = line_sender_column_name_assert(length(name), name);
    column_pointer = Ref{line_sender_utf8}();        

    if column_value isa String
        line_sender_utf8_init(column_pointer, length(column_value), column_value, sender.err);                           
        line_sender_buffer_column_str(sender.buffer, col_name, column_pointer[], sender.err);
    elseif column_value isa Int64
        line_sender_buffer_column_i64(sender.buffer, col_name, column_value, sender.err);                                        
    elseif column_value isa Float64
        line_sender_buffer_column_f64(sender.buffer, col_name, column_value, sender.err);                                        
    elseif column_value isa Bool
        line_sender_buffer_column_bool(sender.buffer, col_name, column_value, sender.err);                                                
    elseif column_value isa Microsecond
        ts = convert(Int64, Dates.value(column_value));            
        line_sender_buffer_column_ts(sender.buffer, col_name, ts, sender.err);                        
    else
        throw("Unsupported type: $(typeof(column_value))");        
    end;

    if (sender.err[] != C_NULL)
        return error_handler(sender.sender, sender.buffer, sender.err);
    end        
    sender
end

"""at
    Adds a column with the given `ts` timestamp to the buffer of the sender object.
        
    Parameters
    ----------
    ts: Dates.Nanosecond
        Timestamp to add to the buffer.

    Returns
    -------
    None

    ## Example
    ```julia
    sender = Sender("localhost", "9000")
    sender.table("my_table", ["col1", "col2"], ["int", "string"])
    sender.column("col1", 1)
    sender.column("col2", "hello")
    ts = Dates.Microsecond(1620000000000)
    sender.at(ts)
    sender.flush()
    ```
"""
function(at::At)(ts::Dates.Nanosecond)    
    sender = at.sender
    ts = convert(Int64, Dates.value(ts));      
    
    line_sender_buffer_at(sender.buffer, ts, sender.err);       

    if (sender.err[] != C_NULL)
        return error_handler(sender.sender, sender.buffer, sender.err);           
    end
    sender
end

"""Sender.at_now
    Adds a column with the current timestamp to the buffer of the sender object.
    
    Returns
    -------
    None

    ## Example
    ```julia
    sender = Sender("localhost", "9000")
    sender.table("my_table")
    sender.column("col1", 1)
    sender.column("col2", "hello")
    sender.at_now()
    sender.flush()
    ```
"""
function(at_now::AtNow)()    
    sender = at_now.sender
    line_sender_buffer_at_now(sender.buffer, sender.err);       

    if (sender.err[] != C_NULL)
        return error_handler(sender.sender, sender.buffer, sender.err);           
    end
    sender
end

"""
    Flush the buffer of the sender object to the database.    

    Notes
    -----
    * The buffer is flushed automatically when the buffer is full.
    * The buffer is flushed automatically when the `Sender` object is garbage collected.
    * The buffer is flushed automatically when the `Sender` object is closed.
"""
function(flush::Flush)()    
    sender = flush.sender
    line_sender_flush(sender.sender, sender.buffer, sender.err);    
    if sender.err[] != C_NULL          
        return error_handler(sender.sender, sender.buffer, sender.err);           
    end;    
end

"""
    Close the sender object.    
            
"""
function(close::Close)()
    println("Closing...");
    sender = close.sender
    line_sender_close(sender.sender);
end

export Sender, capacity

end