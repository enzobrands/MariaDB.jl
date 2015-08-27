@doc doc"""
# Description

Returns the number of affected rows by the last operation associated with mysql, if the operation
was an "upsert" (INSERT, UPDATE, DELETE or REPLACE) statement, or -1 if the last query failed.

When using UPDATE, MariaDB will not update columns where the new value is the same as the old value.
This creates the possibility that mysql_affected_rows may not actually equal the number of rows
matched, only the number of rows that were literally affected by the query.
The REPLACE statement first deletes the record with the same primary key and then inserts the new
record. This function returns the number of deleted records in addition to the number of inserted
records.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_affected_rows(mysql::MYSQL) = ccall( (:mysql_affected_rows, mariadb_lib),
                                            Culonglong, (Ptr{Void}, ),
                                            mysql)

@doc doc"""
# Description

Toggles autocommit mode on or off for the current database connection. Autocommit mode will be set
if auto_mode=true or unset if auto_mode=false. Returns MYSQL_OK on success, or nonzero if an error
occurred.

**Autocommit** mode only affects operations on transactional table types. To determine the current
state of autocommit mode use the SQL command SELECT @@autocommit. Be aware: the *mysql_rollback()*
function will not work if autocommit mode is switched on.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
- **auto_mode** whether to turn autocommit on or not.
"""
mysql_autocommit(mysql::MYSQL, auto_mode::Bool) = ccall( (:mysql_autocommit, mariadb_lib),
                                                          Cint, (Ptr{Void}, Cint),
                                                          mysql, (auto_mode ? 1 : 0))

@doc doc"""
# Description

Changes the user and default database of the current connection.

In order to successfully change users a valid username and password parameters must be provided and
that user must have sufficient permissions to access the desired database. If for any reason
authorization fails, the current user authentication will remain.

Returns MYSQL_OK on success, nonzero if an error occured.

**mysql_change_user** will always cause the current database connection to behave as if was a
completely new database connection, regardless of if the operation was completed successfully. This
reset includes performing a rollback on any active transactions, closing all temporary tables, and
unlocking all locked tables.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
- **user** the user name for server authentication
- **passwd** the password for server authentication
- **db** the default database. If desired, the empty string "" may be passed resulting in only
  changing the user and not selecting a database. To select a database in this case use the
  *mysql_select_db()* function.
"""
mysql_change_user(mysql::MYSQL, user::UTF8String, passwd::UTF8String, db::UTF8String="")
    = ccall( (:mysql_change_user, mariadb_lib), Cint, (Ptr{Void}, Cstring, Cstring, Cstring),
               mysql, user, passwd, (db == "" ? C_NULL : db))

@doc doc"""
# Description

Returns the default client character set for the specified connection.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_character_set_name(mysql::MYSQL) = bytestring(
    ccall( (:mysql_character_set_name, mariadb_lib), Cstring, (Ptr{Void},) mysql))

@doc doc"""
# Description

Closes a previously opened connection.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_close(mysql::MYSQL) = ccall( (:mysql_close, mariadb_lib), Void, (Ptr{Void},), mysql)

@doc doc"""
# Description

Commits the current transaction for the specified database connection. Returns MYSQL_OK on success,
nonzero if an error occurred.

Executing **mysql_commit()** will not affected the behaviour of *autocommit*. This means, any update
or insert statements following mysql_commit() will be rolled back when the connection gets closed.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_commit(mysql::MYSQL) = ccall( (:mysql_commit, mariadb_lib), Cint, (Ptr{Void},), mysql)

@doc doc"""
# Description

The **mysql_data_seek()** function seeks to an arbitrary function result pointer specified by the
offset in the result set.

This function can only be used with buffered result sets obtained from the use of the
*mysql_store_result* function.

# Parameters

- **result** a result set identifier returned by *mysql_store_result()*.
- **offset** the field offset. Must be between 1 and the total number of rows.
"""
mysql_data_seek(result::MYSQL_RES, offset::UInt64) = ccall( (:mysql_data_seek, mariadb_lib),
                                                             Void, (Ptr{Void}, Culonglong),
                                                             result, offset-1)

@doc doc"""
# Description

This function is designed to be executed by an user with the SUPER privilege and is used to dump
server status information into the log for the MariaDB Server relating to the connection.

Returns MYSQL_OK on success, nonzero if an error occurred.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_dump_debug_info(mysql::MYSQL) = ccall( (:mysql_dump_debug_info, mariadb_lib),
                                              Cint, (Ptr{Void},), mysql)

@doc doc"""
# Description

Returns the last error code for the most recent function call that can succeed or fail. Zero means
no error occurred.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_errno(mysql::MYSQL) = ccall( (:mysql_errno, mariadb_lib), Cuint, (Ptr{Void},), mysql)

@doc doc"""
# Description

Returns the last error message for the most recent function call that can succeed or fail. If no
error occurred an empty string is returned.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_error(mysql::MYSQL) = bytestring(
    ccall( (:mysql_error, mariadb_lib), Cstring, (Ptr{Void},), mysql))

@doc doc"""
# Description

Returns the definition of one column of a result set as a MYSQL_FIELD type. Call this function
repeatedly to retrieve information about all columns in the result set.

The field order will be reset if you execute a new SELECT query.
In case only information for a specific field is required the field can be selected by using the
*mysql_field_seek()* function or obtained by *mysql_fetch_field_direct()* function.

# Parameters

- **result** a result set identifier returned by *mysql_store_result()* or *mysql_use_result()*.
"""
function mysql_fetch_field(result::MYSQL_RES)
    ptr = ccall( (:mysql_fetch_field, mariadb_lib), Ptr{_MYSQL_FIELD_}, (Ptr{Void},), result)
    return MYSQL_FIELD(unsafe_load(ptr, 1))
end

@doc doc"""
# Description

This function serves an identical purpose to the mysql_fetch_field() function with the single
difference that instead of returning one field at a time for each field, the fields are returned as
an array. Each field contains the definition for a column of the result set.

# Parameters

- **result** a result set identifier returned by *mysql_store_result()* or *mysql_use_result()*.
"""
function mysql_fetch_fields(result:MYSQL_RES)
    fields = MYSQL_FIELD[]
    num_fields = ccall( (:mysql_num_fields, mariadb_lib), Cuint, (Ptr{Void},), result)
    ptr = ccall( (:mysql_fetch_fields, mariadb_lib), Ptr{_MYSQL_FIELD_}, (Ptr{Void},), result)
    for i in 1:numfields
        field = MYSQL_FIELD(unsafe_load(ptr,i))
        push!(fields, field)
    end
    return fields
end

@doc doc"""
# Description

Returns a pointer to a MYSQL_FIELD structure which contains field information from the specified
result set.

The total number of fields can be obtained by *mysql_field_count()* or *mysql_num_fields()*.

# Parameters

- **result** a result set identifier returned by *mysql_store_result()* or *mysql_use_result()*.
- **fieldnr** the field number. This value must be within the range from 1 to number of fields.
"""
function mysql_fetch_field_direct(result::MYSQL_RES, fieldnr::UInt)
    ptr = ccall( (:mysql_fetch_field_direct, mariadb_lib), Ptr{_MYSQL_FIELD_}, (Ptr{Void}, Cuint),
                  result, fieldnr-1)
    return MYSQL_FIELD(unsafe_load(ptr, 1))
end

@doc doc"""
# Description

The mysql_fetch_lengths() function returns an array containing the lengths of every column of the
current row within the result set (not including terminating zero character) or an empty array if an
error occurred.

**mysql_fetch_lengths()** is valid only for the current row of the result set. It returns an empty
array if you call it before calling *mysql_fetch_row()* or after retrieving all rows in the result.

# Parameters

- **result** a result set identifier returned by *mysql_store_result()* or *mysql_use_result()*.
"""
function mysql_fetch_lengths(result::MYSQL_RES)
    num_fields = ccall( (:mysql_num_fields, mariadb_lib), Cuint, (Ptr{Void},), result)
    ptr = ccall( (:mysql_fetch_lengths, mariadb_lib), Ptr{Cuint}, (Ptr{Void},), result)
    if (ptr != C_NULL)
        return pointer_to_array(ptr, num_fields)
    end
    return UInt[]
end

@doc doc"""
# Description

Fetches one row of data from the result set and returns it as an array of ByteStrings (MYSQL_ROW),
where each column is stored in an offset starting from 1 (one). Each subsequent call to this
function will return the next row within the result set, or an empty array if there are no more
rows.

If a column contains a NULL value the corresponding element will be set to the empty string ("").
Memory associated to MYSQL_ROW will be freed when calling mysql_free_result() function.

# Parameters

- **result** a result set identifier returned by *mysql_store_result()* or *mysql_use_result()*.
"""
function mysql_fetch_row(result::MYSQL_RES)
    row = ByteString[]
    num_fields = ccall( (:mysql_num_fields, mariadb_lib), Cuint, (Ptr{Void},), result)
    ptr = ccall( (:mysql_fetch_row, mariadb_lib), Ptr{Ptr{Uint8}}, (Ptr{Void},), result)
    if (ptr != C_NULL)
        for i in 1:num_fields
            data = bytestring(unsafe_load(ptr,i))
            if data == C_NULL
                push!(row, "")
            else
                push!(row, data)
            end
        end
    end
    return row
end

@doc doc"""
# Description

Returns the number of columns for the most recent query on the connection represented by the link
parameter as an unsigned integer. This function can be useful when using the *mysql_store_result()*
function to determine if the query should have produced a non-empty result set or not without
knowing the nature of the query.

The mysql_field_count() function should be used to determine if there is a result set available.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_field_count(mysql::MYSQL) = ccall( (:mysql_field_count, mariadb_lib), Cuint, (Ptr{Void},),
                                          result)

@doc doc"""
# Description

Sets the field cursor to the given offset. The next call to mysql_fetch_field() will retrieve the
field definition of the column associated with that offset.

Returns the previous value of the field cursor.

The number of fields can be obtained from *mysql_field_count()*.

# Parameters

- **result** a result set identifier returned by *mysql_store_result()* or *mysql_use_result()*.
- **offset** the field number. This number must be in the range from 1..number of fields.
"""
function mysql_field_seek(result::MYSQL_RES, offset::MYSQL_FIELD_OFFSET)
    oldOffset = ccall( (:mysql_field_seek, mariadb_lib), Cuint, (ptr{Void}, Cuint),
                        result, offset-1)
    return oldOffset+1
end

@doc doc"""
# Description

Return the offset of the field cursor used for the last *mysql_fetch_field()* call. This value can
be used as a parameter for the function *mysql_field_seek()*.

# Parameters

- **result** a result set identifier returned by *mysql_store_result()* or *mysql_use_result()*.
"""
function mysql_field_tell(result::MYSQL_RES)
    offset = ccall( (:mysql_field_tell, mariadb_lib), Cuint, (Ptr{Void},), result)
    return offset+1
end

@doc doc"""
# Description

Frees the memory associated with a result set.

You should always free your result set with **mysql_free_result()** as soon it's not needed anymore.
Row values obtained by a prior *mysql_fetch_row()* call will become invalid after calling
*mysql_free_result()*.

# Parameters

- **result** a result set identifier returned by *mysql_store_result()* or *mysql_use_result()*.
"""
mysql_free_result(result::MYSQL_RES) = ccall( (:mysql_free_result, mariadb_lib), Void, (Ptr{Void},),
                                               result)

@doc doc"""
# Description

Returns information about the current default character set for the specified connection.

A complete list of supported character sets in the client library is listed in the function
description for *mysql_set_character_set_info()*.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
function mysql_get_character_set_info(mysql::MYSQL)
    info = _MY_CHARSET_INFO_[0]
    ccall( (:mysql_get_character_set_info, mariadb_lib), Void, (Ptr{Void}, Ref{_MY_CHARSET_INFO_}),
            mysql, info)
    return MY_CHARSET_INFO(info[1])
end

@doc doc"""
# Description

Returns a string representing the client library version.

To obtain the numeric value of the client library version use *mysql_get_client_version()*.
"""
mysql_get_client_info() = bytestring(
    ccall( (:mysql_get_client_info, mariadb_lib), Ptr{Uint8}, (Void,)))

@doc doc"""
# Description

Returns a number representing the client library version.

To obtain a string containing the client library version use the *mysql_get_client_info()* function.
"""
mysql_get_client_version() = ccall( (:mysql_get_client_version, mariadb_lib), Culong, (Void,))

@doc doc"""
# Description

Describes the type of connection in use for the connection, including the server host name. Returns
a string, or "" if the connection is not valid.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
function mysql_get_host_info(mysql::MYSQL)
    ptr = ccall( (:mysql_get_host_info, mariadb_lib), Ptr{Uint8}, (Ptr{Void},), mysql))
    if ptr == C_NULL
        return ""
    end
    return bytestring(ptr)
end

@doc doc"""
# Description

Returns the protocol version number for the specified connection.

The client library doesn't support protocol version 9 and prior.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_get_proto_info(mysql::MYSQL) = ccall( (:mysql_get_proto_info, mariadb_lib), Cuint,
                                            (Ptr{Void},), mysql)

@doc doc"""
# Description

Returns the server version or "" on failure.

To obtain the numeric server version please use mysql_get_server_version().

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
function mysql_get_server_info(mysql::MYSQL)
    ptr = ccall( (:mysql_get_server_info, mariadb_lib), Ptr{Uint8}, (Ptr{Void},), mysql))
    if ptr == C_NULL
        return ""
    end
    return bytestring(ptr)
end

@doc doc"""
# Description

Returns an integer representing the version of connected server.

The form of the version number is VERSION_MAJOR * 10000 + VERSION_MINOR * 100 + VERSION_PATCH.
"""
mysql_get_server_version() = ccall( (:mysql_get_server_version, mariadb_lib), Culong, (Void,))

@doc doc"""
# Description

Returns the name of the currently used cipher of the ssl connection, or "" for non ssl connections.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
function mysql_get_ssl_cipher(mysql::MYSQL)
    ptr = ccall( (:mysql_get_ssl_cipher, mariadb_lib), Ptr{Uint8}, (Ptr{Void},), mysql)
    if ptr == C_NULL
        return ""
    end
    return bytestring(ptr)
end

@doc doc"""
# Description

This function is used to create a hexadecimal string which can be used in SQL statements. e.g.
`INSERT INTO my_blob VALUES(X'A0E1CD')`.

Returns the hexadecimal encoded string.

# Parameters

- **from** the string which will be encoded
"""
function mysql_hex_string(from::String)
    num_bytes = sizeof(from)
    out = Vector{Uint8}(num_bytes * 2 + 1)
    len = ccall( (:mysql_hex_string, mariadb_lib), Culong, (Ptr{Uint8}, Ptr{Uint8}, Culong),
                  out, from, num_bytes)
    r = range(1, Int64(len))
    return (bytestring(getindex(out,r)), len)
end

@doc doc"""
# Description

returns a string providing information about the last query executed. The nature of this string is
provided below:

| Query type                             | Example result string                        |
| -------------------------------------- | -------------------------------------------- |
| INSERT INTO ... SELECT ...             | Records: 100 Duplicates: 0 Warnings: 0       |
| INSERT INTO...VALUES (...),(...),(...) | Records: 3 Duplicates: 0 Warnings: 0         |
| LOAD DATA INFILE ...                   | Records: 1 Deleted: 0 Skipped: 0 Warnings: 0 |
| ALTER TABLE ...                        | Records: 3 Duplicates: 0 Warnings: 0         |
| UPDATE ...                             | Rows matched: 40 Changed: 40 Warnings: 0     |

Queries which do not fall into one of the preceding formats are not supported
(e.g. `SELECT ...`). In these situations mysql_info() will return an empty string.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
function mysql_info(mysql::MYSQL)
    ptr = ccall( (:mysql_info, mariadb_lib), Ptr{Uint8}, (Ptr{Void},), mysql)
    if ptr == C_NULL
        return ""
    end
    return bytestring(ptr)
end

@doc doc"""
# Description

Prepares and initializes a MYSQL structure to be used with mysql_real_connect().

If mysql_thread_init() was not called before, mysql_init() will also initialize the thread subsystem
for the current thread.

Any subsequent calls to any mysql function (except *mysql_options()*) will fail until
*mysql_real_connect()* was called.
Memory allocated by **mysql_init()** must be freed with *mysql_close()*.
"""
mysql_init() = ccall( (:mysql_init, mariadb_lib), Ptr{Void}, (Ptr{Void},), C_NULL)

@doc doc"""
# Descriiption

The **mysql_insert_id()** function returns the ID generated by a query on a table with a column
having the AUTO_INCREMENT attribute. If the last query wasn't an INSERT or UPDATE statement or if
the modified table does not have a column with the AUTO_INCREMENT attribute, this function will
return zero.

Performing an INSERT or UPDATE statement using the LAST_INSERT_ID() function will also modify the
value returned by the mysql_insert_id() function.
When performing a multi insert statement, mysql_insert_id() will return the value of the first row.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_insert_id(mysql::MYSQL) = ccall( (:mysql_insert_id, mariadb_lib), Culonglong, (Ptr{Uint8},),
                                        mysql)

@doc doc"""
# Description

This function is used to ask the server to kill a MariaDB thread specified by the processid
parameter. This value must be retrieved by SHOW PROCESSLIST. If trying to kill the own connection
mysql_thread_id() should be used.

Returns MYSQL_OK on success, otherwise nonzero.

To stop a running command without killing the connection use KILL QUERY. The mysql_kill() function
only kills a connection, it doesn't free any memory - this must be done explicitly by calling
*mysql_close()*.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
- **pid** process id.
"""
mysql_kill(mysql::MYSQL, pid::UInt) = call( (:mysql_kill, mariadb_lib), Cint, (PTr{Uint8}, Culong),
                                             mysql, pid)

@doc doc"""
# Description

Call when finished using the library, such as after disconnecting from the server. In an embedded
server application, the embedded server is shut down and cleaned up. For a client program, only
cleans up by performing memory management tasks.

*mysql_server_end()* is an alias
"""
mysql_library_end() = ccall( (:mysql_library_end, mariadb_lib), Void, (Void,))

@doc doc"""
# Description

Call to initialize the library before calling other functions, both for embedded servers and regular
clients. If used on an embedded server, the server is started and subsystems initialized. Returns
MYSQL_OK for success, or nonzero if an error occurred.

Call *mysql_library_end()* to clean up after completion.

*mysql_server_init()* is an alias.
"""
function mysql_library_init(argv::Vector{String}, groups::Vector{String})
    c_groups::Vector{Ptr{Uint8}}
    for s in groups
        push!(c_groups, pointer(s))
    end
    push!(c_groups, convert(Ptr{Uint8}, C_NULL))
    return ccall( (:mysql_library_init, mariadb_lib), Cint, (Cint, Ptr{Ptr{Uint8}}, Ptr{Ptr{Uint8}}),
                   length(argv), argv, c_groups)
end
mysql_library_init(argv::Vector{String}) = mysql_library_init(argv, Vector{String}[0])
mysql_library_init() = mysql_library_init(Vector{String}[0])

@doc doc"""
# Description

Indicates if one or more result sets are available from a previous call to *mysql_real_query()*.
Returns true if more result sets are available, otherwise false.

The function *mysql_set_server_option()* enables or disables multi statement support.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
function mysql_more_results(mysql::MYSQL)
    retval = ccall( (:mysql_more_results, mariadb_lib), Cint, (Ptr{Void},), mysql)
    return retval == 1
end

@doc doc"""
# Description

Prepares next result set from a previous call to *mysql_real_query()* which can be retrieved by
*mysql_store_result()* or *mysql_use_result()*. Returns MYSQL_OK on success, nonzero if an error
occurred.

If a multi query contains errors the return value of *mysql_errno/error()* might change and there
will be no result set available.

# Parameters

- **mysql** a mysql handle, identifier, which was previously allocated by *mysql_init()* or
  *mysql_real_connect()*.
"""
mysql_next_result(mysql::MYSQL) = ccall( (:mysql_next_result, mariadb_lib), Cint, (Ptr{Void},),
                                          mysql)

@doc doc"""
# Description

Returns number of fields in a specified result set.

# Parameters

- **Result** A result set identifier returned by *mysql_store_result()* or *mysql_use_result()*.
"""
mysql_num_fields(result:MYSQL_RES) = ccall( (:mysql_num_fields, mariadb_lib), Cuint, (Ptr{Void}),
                                             result)

@doc doc"""
# Description

Returns number of rows in a result set.

The behaviour of mysql_num_rows() depends on whether buffered or unbuffered result sets are being
used. For unbuffered result sets, *mysql_num_rows()* will not return the correct number of rows
until all the rows in the result have been retrieved.

# Parameters

- **Result** A result set identifier returned by *mysql_store_result()* or *mysql_use_result()*.
"""
mysql_num_rows(result::MYSQL_RES) = ccall( (:mysql_num_rows, mariadb_lib), Culonglong, (Ptr{Void}),
                                            result)
