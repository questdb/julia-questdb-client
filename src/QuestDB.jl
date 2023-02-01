
module QuestDB

include("LibQuestDB.jl")
using .LibQuestDB 
using Dates

err = Ref{Ptr{line_sender_error}}(C_NULL)
opts = Ref{line_sender_opts}()
sender = Ref{line_sender}()

host_utf8 = Ref{line_sender_utf8}()
port_utf8 = Ref{line_sender_utf8}()
key_id_utf8 = Ref{line_sender_utf8}()
priv_key_utf8 = Ref{line_sender_utf8}()
pub_key_x_utf8 = Ref{line_sender_utf8}()
pub_key_y_utf8 = Ref{line_sender_utf8}()


function error_handler(err::Ref{Ptr{line_sender_error}})        
    
    code = line_sender_error_get_code(err[])
    len = Ref{Csize_t}(100)
    message = line_sender_error_msg(err[], len)     
    #line_sender_opts_free(opts);
    #line_sender_error_free(err);
    #line_sender_buffer_free(buffer);
    #line_sender_close(sender);
    throw("Error code: $(code) Message: $(unsafe_string(message, len[]))")    
    #return false;    
end

function Sender(host, port, auth=nothing, tls=false)        
 
    is_host_ok = line_sender_utf8_init(host_utf8, length(host), host, err)    
    is_port_ok = line_sender_utf8_init(port_utf8, length(port), port, err)
            
    if (is_host_ok && is_port_ok)            
        opts = line_sender_opts_new_service(host_utf8[], port_utf8[])                        

        if (tls)
            line_sender_opts_tls(opts);
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
            return error_handler(err)                        
        end            
    else            
        error_handler(err)
    end;
    
    buffer = line_sender_buffer_new()
    line_sender_buffer_reserve(buffer, 64 * 1024);
    
    table(name::String) = (
        table_name = line_sender_table_name_assert(length(name), name);                                         
        line_sender_buffer_table(buffer, table_name, err);                        
        
        if (err[] != C_NULL)
            error_handler(err)            
        end
    );  

    symbol(name::String, column_value::String) = (
        col_name = line_sender_column_name_assert(length(name), name);
        column_pointer = Ref{line_sender_utf8}();
        
        line_sender_utf8_init(column_pointer, length(column_value), column_value, err);                           
        line_sender_buffer_symbol(buffer, col_name, column_pointer[], err);

        if (err[] != C_NULL)
            return error_handler(err)            
        end
    );

    column(name::String, column_value) = (                    
        col_name = line_sender_column_name_assert(length(name), name);
        column_pointer = Ref{line_sender_utf8}();
               
        if (typeof(column_value) == String)            
            line_sender_utf8_init(column_pointer, length(column_value), column_value, err);                           
            line_sender_buffer_column_str(buffer, col_name, column_pointer[], err);
        elseif (typeof(column_value) == Int64)            
            line_sender_buffer_column_i64(buffer, col_name, column_value, err);                                        
        elseif (typeof(column_value) == Float64)
            line_sender_buffer_column_f64(buffer, col_name, column_value, err);                                        
        elseif (typeof(column_value) == Bool)
            line_sender_buffer_column_bool(buffer, col_name, column_value, err);                                                
        else
            throw("Unsupported type: $(typeof(column_value))");        
        end;

        if (err[] != C_NULL)
            return error_handler(err)            
        end        
    )

    at_now() = (
        line_sender_buffer_at_now(buffer, err);        
        if (err[] != C_NULL)
            return error_handler(err)            
        end
    )

    at(ts::Dates.Nanosecond) = (                
        ts = convert(Int64, Dates.value(ts));        
        line_sender_buffer_at(buffer, ts, err);       

        if (err[] != C_NULL)
            return error_handler(err)            
        end
    )    
    
    flush() = (                                         
        println("Flushing...");
        line_sender_flush(sender, buffer, err);
        line_sender_close(sender); 
           
        if err[] != C_NULL  
            return error_handler(err)
        end;

    );

    return () -> (table, symbol, column, at_now, at, flush)
    
end

export Sender

end