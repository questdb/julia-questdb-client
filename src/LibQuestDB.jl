module LibQuestDB

using CEnum
using c_questdb_client_jll
export c_questdb_client_jll

"""
    line_sender_utf8

Non-owning validated UTF-8 encoded string. The string need not be null-terminated.
"""
struct line_sender_utf8
    len::Csize_t
    buf::Ptr{Cchar}
end

"""
    line_sender_utf8_assert(len, buf)

Construct a UTF-8 object from UTF-8 encoded buffer and length. If the passed in buffer is not valid UTF-8, the program will abort.

### Parameters
* `len`:\\[in\\] Length in bytes of the buffer.
* `buf`:\\[in\\] UTF-8 encoded buffer.
"""
function line_sender_utf8_assert(len, buf)
    ccall((:line_sender_utf8_assert, libquestdb_client), line_sender_utf8, (Csize_t, Ptr{Cchar}), len, buf)
end

"""
    line_sender_table_name

Non-owning validated table, symbol or column name. UTF-8 encoded. Need not be null-terminated.
"""
struct line_sender_table_name
    len::Csize_t
    buf::Ptr{Cchar}
end

"""
    line_sender_table_name_assert(len, buf)

Construct a table name object from UTF-8 encoded buffer and length. If the passed in buffer is not valid UTF-8, or is not a valid table name, the program will abort.

### Parameters
* `len`:\\[in\\] Length in bytes of the buffer.
* `buf`:\\[in\\] UTF-8 encoded buffer.
"""
function line_sender_table_name_assert(len, buf)
    ccall((:line_sender_table_name_assert, libquestdb_client), line_sender_table_name, (Csize_t, Ptr{Cchar}), len, buf)
end

"""
    line_sender_column_name

Non-owning validated table, symbol or column name. UTF-8 encoded. Need not be null-terminated.
"""
struct line_sender_column_name
    len::Csize_t
    buf::Ptr{Cchar}
end

"""
    line_sender_column_name_assert(len, buf)

Construct a column name object from UTF-8 encoded buffer and length. If the passed in buffer is not valid UTF-8, or is not a valid column name, the program will abort.

### Parameters
* `len`:\\[in\\] Length in bytes of the buffer.
* `buf`:\\[in\\] UTF-8 encoded buffer.
"""
function line_sender_column_name_assert(len, buf)
    ccall((:line_sender_column_name_assert, libquestdb_client), line_sender_column_name, (Csize_t, Ptr{Cchar}), len, buf)
end

mutable struct line_sender_error end

"""
    line_sender_error_code

Category of error.
"""
@cenum line_sender_error_code::UInt32 begin
    line_sender_error_could_not_resolve_addr = 0
    line_sender_error_invalid_api_call = 1
    line_sender_error_socket_error = 2
    line_sender_error_invalid_utf8 = 3
    line_sender_error_invalid_name = 4
    line_sender_error_invalid_timestamp = 5
    line_sender_error_auth_error = 6
    line_sender_error_tls_error = 7
end

"""
    line_sender_error_get_code(arg1)

Error code categorizing the error.
"""
function line_sender_error_get_code(arg1)
    ccall((:line_sender_error_get_code, libquestdb_client), line_sender_error_code, (Ptr{line_sender_error},), arg1)
end

"""
    line_sender_error_msg(arg1, len_out)

UTF-8 encoded error message. Never returns NULL. The `len_out` argument is set to the number of bytes in the string. The string is NOT null-terminated.
"""
function line_sender_error_msg(arg1, len_out)
    ccall((:line_sender_error_msg, libquestdb_client), Ptr{Cchar}, (Ptr{line_sender_error}, Ptr{Csize_t}), arg1, len_out)
end

"""
    line_sender_error_free(arg1)

Clean up the error.
"""
function line_sender_error_free(arg1)
    ccall((:line_sender_error_free, libquestdb_client), Cvoid, (Ptr{line_sender_error},), arg1)
end

"""
    line_sender_utf8_init(str, len, buf, err_out)

Check the provided buffer is a valid UTF-8 encoded string.

### Parameters
* `str`:\\[out\\] The object to be initialized.
* `len`:\\[in\\] Length in bytes of the buffer.
* `buf`:\\[in\\] UTF-8 encoded buffer. Need not be null-terminated.
* `err_out`:\\[out\\] Set on error.
### Returns
true on success, false on error.
"""
function line_sender_utf8_init(str, len, buf, err_out) 
    ccall((:line_sender_utf8_init, libquestdb_client), Bool, (Ptr{line_sender_utf8}, Csize_t, Ptr{Cchar}, Ptr{Ptr{line_sender_error}}), str, len, buf, err_out)
end

"""
    line_sender_table_name_init(name, len, buf, err_out)

Check the provided buffer is a valid UTF-8 encoded string that can be used as a table name.

### Parameters
* `name`:\\[out\\] The object to be initialized.
* `len`:\\[in\\] Length in bytes of the buffer.
* `buf`:\\[in\\] UTF-8 encoded buffer. Need not be null-terminated.
* `err_out`:\\[out\\] Set on error.
### Returns
true on success, false on error.
"""
function line_sender_table_name_init(name, len, buf, err_out)
    ccall((:line_sender_table_name_init, libquestdb_client), Bool, (Ptr{line_sender_table_name}, Csize_t, Ptr{Cchar}, Ptr{Ptr{line_sender_error}}), name, len, buf, err_out)
end

"""
    line_sender_column_name_init(name, len, buf, err_out)

Check the provided buffer is a valid UTF-8 encoded string that can be used as a symbol name or column name.

### Parameters
* `name`:\\[out\\] The object to be initialized.
* `len`:\\[in\\] Length in bytes of the buffer.
* `buf`:\\[in\\] UTF-8 encoded buffer. Need not be null-terminated.
* `err_out`:\\[out\\] Set on error.
### Returns
true on success, false on error.
"""
function line_sender_column_name_init(name, len, buf, err_out)
    ccall((:line_sender_column_name_init, libquestdb_client), Bool, (Ptr{line_sender_column_name}, Csize_t, Ptr{Cchar}, Ptr{Ptr{line_sender_error}}), name, len, buf, err_out)
end

mutable struct line_sender_buffer end

# no prototype is found for this function at line_sender.h:235:21, please use with caution
"""
    line_sender_buffer_new()

Create a buffer for serializing ILP messages.
"""
function line_sender_buffer_new()
    ccall((:line_sender_buffer_new, libquestdb_client), Ptr{line_sender_buffer}, ())
end


"""
    line_sender_buffer_with_max_name_len(max_name_len)

Create a buffer for serializing ILP messages.
"""
function line_sender_buffer_with_max_name_len(max_name_len)
    ccall((:line_sender_buffer_with_max_name_len, libquestdb_client), Ptr{line_sender_buffer}, (Csize_t,), max_name_len)
end

"""
    line_sender_buffer_free(buffer)

Release the buffer object.
"""
function line_sender_buffer_free(buffer)
    ccall((:line_sender_buffer_free, libquestdb_client), Cvoid, (Ptr{line_sender_buffer},), buffer)
end

"""
    line_sender_buffer_clone(buffer)

Create a new copy of the buffer.
"""
function line_sender_buffer_clone(buffer)
    ccall((:line_sender_buffer_clone, libquestdb_client), Ptr{line_sender_buffer}, (Ptr{line_sender_buffer},), buffer)
end

"""
    line_sender_buffer_reserve(buffer, additional)

Pre-allocate to ensure the buffer has enough capacity for at least the specified additional byte count. This may be rounded up. This does not allocate if such additional capacity is already satisfied. See: `capacity`.
"""
function line_sender_buffer_reserve(buffer, additional)
    ccall((:line_sender_buffer_reserve, libquestdb_client), Cvoid, (Ptr{line_sender_buffer}, Csize_t), buffer, additional)
end

"""
    line_sender_buffer_capacity(buffer)

Get the current capacity of the buffer.
"""
function line_sender_buffer_capacity(buffer)
    ccall((:line_sender_buffer_capacity, libquestdb_client), Csize_t, (Ptr{line_sender_buffer},), buffer)
end

"""
    line_sender_buffer_set_marker(buffer, err_out)

Mark a rewind point. This allows undoing accumulated changes to the buffer for one or more rows by calling `rewind_to_marker`. Any previous marker will be discarded. Once the marker is no longer needed, call `clear_marker`.
"""
function line_sender_buffer_set_marker(buffer, err_out)
    ccall((:line_sender_buffer_set_marker, libquestdb_client), Bool, (Ptr{line_sender_buffer}, Ptr{Ptr{line_sender_error}}), buffer, err_out)
end

"""
    line_sender_buffer_rewind_to_marker(buffer, err_out)

Undo all changes since the last `set_marker` call. As a side-effect, this also clears the marker.
"""
function line_sender_buffer_rewind_to_marker(buffer, err_out)
    ccall((:line_sender_buffer_rewind_to_marker, libquestdb_client), Bool, (Ptr{line_sender_buffer}, Ptr{Ptr{line_sender_error}}), buffer, err_out)
end

"""
    line_sender_buffer_clear_marker(buffer)

Discard the marker.
"""
function line_sender_buffer_clear_marker(buffer)
    ccall((:line_sender_buffer_clear_marker, libquestdb_client), Cvoid, (Ptr{line_sender_buffer},), buffer)
end

"""
    line_sender_buffer_clear(buffer)

Remove all accumulated data and prepare the buffer for new lines. This does not affect the buffer's capacity.
"""
function line_sender_buffer_clear(buffer)
    ccall((:line_sender_buffer_clear, libquestdb_client), Cvoid, (Ptr{line_sender_buffer},), buffer)
end

"""
    line_sender_buffer_size(buffer)

Number of bytes in the accumulated buffer.
"""
function line_sender_buffer_size(buffer)
    ccall((:line_sender_buffer_size, libquestdb_client), Csize_t, (Ptr{line_sender_buffer},), buffer)
end

"""
    line_sender_buffer_peek(buffer, len_out)

Peek into the accumulated buffer that is to be sent out at the next `flush`.

### Parameters
* `buffer`:\\[in\\] Line buffer object.
* `len_out`:\\[out\\] The length in bytes of the accumulated buffer.
### Returns
UTF-8 encoded buffer. The buffer is not nul-terminated.
"""
function line_sender_buffer_peek(buffer, len_out)
    ccall((:line_sender_buffer_peek, libquestdb_client), Ptr{Cchar}, (Ptr{line_sender_buffer}, Ptr{Csize_t}), buffer, len_out)
end

"""
    line_sender_buffer_table(buffer, name, err_out)

Start batching the next row of input for the named table.

### Parameters
* `buffer`:\\[in\\] Line buffer object.
* `name`:\\[in\\] Table name.
"""
function line_sender_buffer_table(buffer, name, err_out)
    ccall((:line_sender_buffer_table, libquestdb_client), Bool, (Ptr{line_sender_buffer}, line_sender_table_name, Ptr{Ptr{line_sender_error}}), buffer, name, err_out)
end

"""
    line_sender_buffer_symbol(buffer, name, value, err_out)

Append a value for a SYMBOL column. Symbol columns must always be written before other columns for any given row.

### Parameters
* `buffer`:\\[in\\] Line buffer object.
* `name`:\\[in\\] Column name.
* `value`:\\[in\\] Column value.
* `err_out`:\\[out\\] Set on error.
### Returns
true on success, false on error.
"""
function line_sender_buffer_symbol(buffer, name, value, err_out)
    ccall((:line_sender_buffer_symbol, libquestdb_client), Bool, (Ptr{line_sender_buffer}, line_sender_column_name, line_sender_utf8, Ptr{Ptr{line_sender_error}}), buffer, name, value, err_out)
end

"""
    line_sender_buffer_column_bool(buffer, name, value, err_out)

Append a value for a BOOLEAN column.

### Parameters
* `buffer`:\\[in\\] Line buffer object.
* `name`:\\[in\\] Column name.
* `value`:\\[in\\] Column value.
* `err_out`:\\[out\\] Set on error.
### Returns
true on success, false on error.
"""
function line_sender_buffer_column_bool(buffer, name, value, err_out)
    ccall((:line_sender_buffer_column_bool, libquestdb_client), Bool, (Ptr{line_sender_buffer}, line_sender_column_name, Bool, Ptr{Ptr{line_sender_error}}), buffer, name, value, err_out)
end

"""
    line_sender_buffer_column_i64(buffer, name, value, err_out)

Append a value for a LONG column.

### Parameters
* `buffer`:\\[in\\] Line buffer object.
* `name`:\\[in\\] Column name.
* `value`:\\[in\\] Column value.
* `err_out`:\\[out\\] Set on error.
### Returns
true on success, false on error.
"""
function line_sender_buffer_column_i64(buffer, name, value, err_out)
    ccall((:line_sender_buffer_column_i64, libquestdb_client), Bool, (Ptr{line_sender_buffer}, line_sender_column_name, Int64, Ptr{Ptr{line_sender_error}}), buffer, name, value, err_out)
end

"""
    line_sender_buffer_column_f64(buffer, name, value, err_out)

Append a value for a DOUBLE column.

### Parameters
* `buffer`:\\[in\\] Line buffer object.
* `name`:\\[in\\] Column name.
* `value`:\\[in\\] Column value.
* `err_out`:\\[out\\] Set on error.
### Returns
true on success, false on error.
"""
function line_sender_buffer_column_f64(buffer, name, value, err_out)
    ccall((:line_sender_buffer_column_f64, libquestdb_client), Bool, (Ptr{line_sender_buffer}, line_sender_column_name, Cdouble, Ptr{Ptr{line_sender_error}}), buffer, name, value, err_out)
end

"""
    line_sender_buffer_column_str(buffer, name, value, err_out)

Append a value for a STRING column.

### Parameters
* `buffer`:\\[in\\] Line buffer object.
* `name`:\\[in\\] Column name.
* `value`:\\[in\\] Column value.
* `err_out`:\\[out\\] Set on error.
### Returns
true on success, false on error.
"""
function line_sender_buffer_column_str(buffer, name, value, err_out)
    ccall((:line_sender_buffer_column_str, libquestdb_client), Bool, (Ptr{line_sender_buffer}, line_sender_column_name, line_sender_utf8, Ptr{Ptr{line_sender_error}}), buffer, name, value, err_out)
end

"""
    line_sender_buffer_column_ts(buffer, name, micros, err_out)

Append a value for a TIMESTAMP column.

### Parameters
* `buffer`:\\[in\\] Line buffer object.
* `name`:\\[in\\] Column name.
* `micros`:\\[in\\] The timestamp in microseconds since the unix epoch.
* `err_out`:\\[out\\] Set on error.
### Returns
true on success, false on error.
"""
function line_sender_buffer_column_ts(buffer, name, micros, err_out)
    ccall((:line_sender_buffer_column_ts, libquestdb_client), Bool, (Ptr{line_sender_buffer}, line_sender_column_name, Int64, Ptr{Ptr{line_sender_error}}), buffer, name, micros, err_out)
end

"""
    line_sender_buffer_at(buffer, epoch_nanos, err_out)

Complete the row with a specified timestamp.

After this call, you can start batching the next row by calling `table` again, or you can send the accumulated batch by calling `flush`.

### Parameters
* `buffer`:\\[in\\] Line buffer object.
* `epoch_nanos`:\\[in\\] Number of nanoseconds since 1st Jan 1970 UTC.
* `err_out`:\\[out\\] Set on error.
### Returns
true on success, false on error.
"""
function line_sender_buffer_at(buffer, epoch_nanos, err_out)
    ccall((:line_sender_buffer_at, libquestdb_client), Bool, (Ptr{line_sender_buffer}, Int64, Ptr{Ptr{line_sender_error}}), buffer, epoch_nanos, err_out)
end

"""
    line_sender_buffer_at_now(buffer, err_out)

Complete the row without providing a timestamp. The QuestDB instance will insert its own timestamp.

After this call, you can start batching the next row by calling `table` again, or you can send the accumulated batch by calling `flush`.

### Parameters
* `buffer`:\\[in\\] Line buffer object.
* `err_out`:\\[out\\] Set on error.
### Returns
true on success, false on error.
"""
function line_sender_buffer_at_now(buffer, err_out)
    ccall((:line_sender_buffer_at_now, libquestdb_client), Bool, (Ptr{line_sender_buffer}, Ptr{Ptr{line_sender_error}}), buffer, err_out)    
end

mutable struct line_sender end

mutable struct line_sender_opts end

"""
    line_sender_opts_new(host, port)

A new set of options for a line sender connection.

### Parameters
* `host`:\\[in\\] The QuestDB database host.
* `port`:\\[in\\] The QuestDB database port.
"""
function line_sender_opts_new(host, port)
    ccall((:line_sender_opts_new, libquestdb_client), Ptr{line_sender_opts}, (line_sender_utf8, UInt16), host, port)
end

"""
    line_sender_opts_xhost, port)

A new set of options for a line sender connection.

### Parameters
* `host`:\\[in\\] The QuestDB database host.
* `port`:\\[in\\] The QuestDB database port as service name.
"""
function line_sender_opts_new_service(host, port)    
    ccall((:line_sender_opts_new_service, libquestdb_client), Ptr{line_sender_opts}, (line_sender_utf8, line_sender_utf8), host, port)    
end

"""
    line_sender_opts_net_interface(opts, net_interface)

Select local outbound interface.
"""
function line_sender_opts_net_interface(opts, net_interface)
    ccall((:line_sender_opts_net_interface, libquestdb_client), Cvoid, (Ptr{line_sender_opts}, line_sender_utf8), opts, net_interface)
end

"""
    line_sender_opts_auth(opts, key_id, priv_key, pub_key_x, pub_key_y)

Authentication Parameters.

### Parameters
* `key_id`:\\[in\\] Key id. AKA "kid"
* `priv_key`:\\[in\\] Private key. AKA "d".
* `pub_key_x`:\\[in\\] Public key X coordinate. AKA "x".
* `pub_key_y`:\\[in\\] Public key Y coordinate. AKA "y".
"""
function line_sender_opts_auth(opts, key_id, priv_key, pub_key_x, pub_key_y)
    ccall((:line_sender_opts_auth, libquestdb_client), Cvoid, (Ptr{line_sender_opts}, line_sender_utf8, line_sender_utf8, line_sender_utf8, line_sender_utf8), opts, key_id, priv_key, pub_key_x, pub_key_y)
end

"""
    line_sender_opts_tls(opts)

Enable full connection encryption via TLS. The connection will accept certificates by well-known certificate authorities as per the "webpki-roots" Rust crate.
"""
function line_sender_opts_tls(opts)
    ccall((:line_sender_opts_tls, libquestdb_client), Cvoid, (Ptr{line_sender_opts},), opts)
end

"""
    line_sender_opts_tls_ca(opts, ca_path)

Enable full connection encryption via TLS. The connection will accept certificates by the specified certificate authority file.
"""
function line_sender_opts_tls_ca(opts, ca_path)
    ccall((:line_sender_opts_tls_ca, libquestdb_client), Cvoid, (Ptr{line_sender_opts}, line_sender_utf8), opts, ca_path)
end

"""
    line_sender_opts_tls_insecure_skip_verify(opts)

Enable TLS whilst dangerously accepting any certificate as valid. This should only be used for debugging. Consider using calling "tls\\_ca" instead.
"""
function line_sender_opts_tls_insecure_skip_verify(opts)
    ccall((:line_sender_opts_tls_insecure_skip_verify, libquestdb_client), Cvoid, (Ptr{line_sender_opts},), opts)
end

"""
    line_sender_opts_read_timeout(opts, timeout_millis)

Configure how long to wait for messages from the QuestDB server during the TLS handshake and authentication process. The default is 15 seconds.
"""
function line_sender_opts_read_timeout(opts, timeout_millis)
    ccall((:line_sender_opts_read_timeout, libquestdb_client), Cvoid, (Ptr{line_sender_opts}, UInt64), opts, timeout_millis)
end

"""
    line_sender_opts_clone(opts)

Duplicate the opts object. Both old and new objects will have to be freed.
"""
function line_sender_opts_clone(opts)
    ccall((:line_sender_opts_clone, libquestdb_client), Ptr{line_sender_opts}, (Ptr{line_sender_opts},), opts)
end

"""
    line_sender_opts_free(opts)

Release the opts object.
"""
function line_sender_opts_free(opts)
    ccall((:line_sender_opts_free, libquestdb_client), Cvoid, (Ptr{line_sender_opts},), opts)
end

"""
    line_sender_connect(opts, err_out)

Synchronously connect to the QuestDB database. The connection should be accessed by only a single thread a time.

!!! note

    The opts object is freed.

### Parameters
* `opts`:\\[in\\] Options for the connection.
"""
function line_sender_connect(opts, err_out)        
    ccall((:line_sender_connect, libquestdb_client), Ptr{line_sender}, (Ptr{line_sender_opts}, Ptr{Ptr{line_sender_error}}), opts, err_out)    
end



"""
    line_sender_flush(sender, buffer, err_out)

Send buffer of rows to the QuestDB server.

The buffer will be automatically cleared, ready for re-use. If instead you want to preserve the buffer contents, call `flush_and_keep`.

### Parameters
* `sender`:\\[in\\] Line sender object.
* `buffer`:\\[in\\] Line buffer object.
### Returns
true on success, false on error.
"""
function line_sender_flush(sender, buffer, err_out)
    ccall((:line_sender_flush, libquestdb_client), Bool, (Ptr{line_sender}, Ptr{line_sender_buffer}, Ptr{Ptr{line_sender_error}}), sender, buffer, err_out)
end

"""
    line_sender_flush_and_keep(sender, buffer, err_out)

Send buffer of rows to the QuestDB server.

The buffer will left untouched and must be cleared before re-use. To send and clear in one single step, `flush` instead.

### Parameters
* `sender`:\\[in\\] Line sender object.
* `buffer`:\\[in\\] Line buffer object.
### Returns
true on success, false on error.
"""
function line_sender_flush_and_keep(sender, buffer, err_out)
    ccall((:line_sender_flush_and_keep, libquestdb_client), Bool, (Ptr{line_sender}, Ptr{line_sender_buffer}, Ptr{Ptr{line_sender_error}}), sender, buffer, err_out)
end

"""
    line_sender_must_close(sender)

Check if an error occurred previously and the sender must be closed.

### Parameters
* `sender`:\\[in\\] Line sender object.
### Returns
true if an error occurred with a sender and it must be closed.
"""
function line_sender_must_close(sender)
    ccall((:line_sender_must_close, libquestdb_client), Bool, (Ptr{line_sender},), sender)
end

"""
    line_sender_close(sender)

Close the connection. Does not flush. Non-idempotent.

### Parameters
* `sender`:\\[in\\] Line sender object.
"""
function line_sender_close(sender)
    ccall((:line_sender_close, libquestdb_client), Cvoid, (Ptr{line_sender},), sender)
end

export line_sender_utf8, line_sender_utf8_assert, line_sender_utf8_init, line_sender_utf8_init, line_sender_table_name, line_sender_table_name_assert, line_sender_column_name, line_sender_column_name_assert, line_sender_error, line_sender_error_code, line_sender_error_get_code, line_sender_error_msg, line_sender_error_free, line_sender_utf8_init, line_sender_table_name_init, line_sender_column_name_init, line_sender_buffer_new, line_sender_buffer_with_max_name_len, line_sender_buffer_free, line_sender_buffer_clone, line_sender_buffer_reserve, line_sender_buffer_capacity, line_sender_buffer_set_marker, line_sender_buffer_rewind_to_marker, line_sender_buffer_clear_marker, line_sender_buffer_clear, line_sender_buffer_size, line_sender_buffer_peek, line_sender_buffer_table, line_sender_buffer_symbol, line_sender_buffer_column_bool, line_sender_buffer_column_i64, line_sender_buffer_column_f64, line_sender_buffer_column_str, line_sender_buffer_column_ts, line_sender_buffer_at, line_sender_buffer_at_now, line_sender, line_sender_opts, line_sender_opts_new, line_sender_opts_new_service, line_sender_opts_net_interface, line_sender_opts_auth, line_sender_opts_tls, line_sender_opts_tls_ca, line_sender_opts_tls_insecure_skip_verify, line_sender_opts_read_timeout, line_sender_opts_clone, line_sender_opts_free, line_sender_connect, line_sender_flush, line_sender_flush_and_keep, line_sender_must_close, line_sender_close

end # module



