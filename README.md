# MariaDB.jl

[![Build Status](https://travis-ci.org/JuliaLang/METADATA.jl.svg?branch=metadata-v2)](https://travis-ci.org/JuliaLang/METADATA.jl)

A wrapper around the MariaDB C connector.

## Install

Before using MariaDB, make sure you have the MariaDB c connector installed:
[MariaDB C Connector](https://downloads.mariadb.org/connector-c/)

You can install MariaDB.jl via the Julia package manager:
```julia
julia> Pkg.clone("https://github.com/Dynactionize/MariaDB.jl.git")
julia> using MariaDB
```

<!--
```julia
julia> Pkg.update()
julia> Pkg.add("MariaDB")
julia> using MariaDB
```
-->

## Documentation

The wrapper is an almost one-on-one mapping of the interface of the C connector. You can retrieve the documentation via the inline Julia help system.

More documentation can also be found on the [MariaDB C Connector - API Ref](https://mariadb.com/kb/en/mariadb/mariadb-client-library-for-c-api-functions/).

Some MariaDB.jl specific documentation can be found in the following sections.

### Types

The following types are availabe:

* `MYSQL`

  Represents a handle to one database connection. It is used for almost all functions.

* `MYSQL_RES`

  Represents the result of a query that returns rows (`SELECT`, `SHOW`, `DESCRIBE`, `EXPLAIN`). The information returned from a query is calle the result set.

* `MYSQL_ROW`

  This is a type-safe representation of one row of data. It is currently implemented as an array of bytestrings (`Vector{ByteString}`).

* `MYSQL_FIELD`

  Contains metadata: information about a field, such as the field's name, type and size. It has the following members:

  - `name`

    The name of the field. If the fies was given an alias with an `AS` clause, the value of the `name` is the alias

  - `org_name`

    The name of the fiels. Aliases are ignored. For expressions, the value is an empty string

  - `table`

    The name of the table containting this field, if it is not a calculated field. For calculated fields, the `table` value is an empty string. If the column is selected from a view, `table` names the view. IF teh table or view was given an alias, with an `AS` clause, the value of `table` is the alias. for a `UNION` the value is the empty string.

  - `org_table`

    The name of teh table. Aliases are ignored. If the column is selected from a view, `org_table` names the view. For a `UNION` the value is the empty string.

  - `db`

    The The name of the database that the field comes from. If the field is a calculated field, `db` is an empty string. For a `UNION`, the value is the empty string.

  - `catalog`

    The catalog name. This value is always `"def"`.

  - `def`

    The default value of this field.

  - `length`

    The width of the field, This corresponds to the display length, in bytes.

    The server determines the `length` value before it generates the result set, so this is the minimum length required for a data type capable of holding the largest possible value from the result column, without knowing in advance the actual values that will be produced by the query for the result set.

  - `max_length`

    The maximum width of the field for the result set (the length in bytes of the longest field value for the rows actually in the result set). If you use `mysql_store_result()`, this contains the maximum length for the field. If you use `mysql_use_result()`, the value of this variable is zero.

    The value of `max_length` is the length of the string representation of teh values in the result set. For example, if you retrieve a `FLOAT` column and the *widest* value is `-12.345`, `max_length` is 7 (the length of `"-12.345"`).

  - `flags`

    Bit-flag that describes the field. The `flags` value may have zero or more of the bits set that are shown in the following table:

    | **Flag Value**          | **Flag Description**                                             |
    | ----------------------- | ---------------------------------------------------------------- |
    | `NOT_NULL_FLAG`         | Field can not be `NULL`                                          |
    | `PRI_KEY_FLAG`          | Field is part of a primary key                                   |
    | `UNIQUE_KEY_FLAG`       | Field is part of a unique key                                    |
    | `MULTIPLE_KEY_FLAG`     | Field is part of a nonunique key                                 |
    | `UNSIGNED_FLAG`         | Field has the `UNSIGNED` attribute                               |
    | `ZEROFILL_FLAG`         | Field has the `ZEROFILL` attribute                               |
    | `BINARY_FLAG`           | Field has the `BINARY` attribute                                 |
    | `AUTO_INCREMENT_FLAG`   | Field has the `AUTO_INCREMENT` attributes                        |
    | `ENUM_FLAG`             | Field is an `ENUM`                                               |
    | `SET_FLAG`              | Field is a `SET`                                                 |
    | `BLOB_FLAG`             | Field is a `BLOB` or `TEXT` (deprecated)                         |
    | `TIMESTAMP_FLAG`        | Field is a `TIMESTAMP` (deprecated)                              |
    | `NUM_FLAG`              | Field is numeric; see additional notes following table           |
    | `NO_DEFAULT_VALUE_FLAG` | Field has no default value; see additional notes following table |

    Some of these falgs indicate data type information and are superseded by or used in conjunction with the `MYSQL_TYPE_xxx` value in the `field.type` member described later:

    - To check for `BLOB` or `TIMESTAMP` values, check wether `type` is `MYSQL_TYPE_BLOB` or `MYSQL_TYPE_TIMESTAMP`. (The `BLOB_FLAG` and `TIMESTAMP_FLAG` flags are unneeded.)

    - `ENUM` and `SET` values are returned as strings. For these, check that the `type` value is `MYSQL_TYPE_STRING` and that the `ENUM_FLAG` or `SET_FLAG` is set in teh `flags` value.

    `NUM_FLAG` indicates that a column is numeric. This includes columns with a decimal, integer, floating point, NULL and year value.

    `NO_DEFAULT_VALUE_FLAG` indicates that a column has no `DEFAULT` clause in it's definition. This does not apply to `NULL` columns (because such columns have a default `NULL`), or to `AUTO_INCREMENT` columns (which have an implied default value).

  - `decimals`

    The number of decimals for numeric fields.

  - `charsetnr`

    An ID number that indicates the characterset/collactino pair for the field.

    To distinguish between binary and nonbinary data for string data types, check wether the `charsetnr` value is 63. If so, the character set is *binary*, which indicates binary rather than nonbinary data. This enables you to distinguis `BINARY` from `CHAR`, `VARBINARY` from `VARCHAR`, and the `BLOB` types from the `TEXT` types.

    `charsetnr` values are the same as those displayed in the `Id` column of teh `SHOW COLLATION` statement or the `ID` column of the `INFORMATION_SCHEMA.COLLATIONS` table. You can use those information sources to see which character set and collation specific `charsetnr` values indicate.

  - `field_types`

    The type of teh field. The `type` value may be one of the `MYSQL_TYPE_` symbols shown in the
    following table:

    | **Type Value**        | **Type Description**                         |
    | --------------------- | -------------------------------------------- |
    | MYSQL_TYPE_TINY       | 1-byte integer field                         |
    | MYSQL_TYPE_SHORT      | 2-byte integer field                         |
    | MYSQL_TYPE_LONG       | 4-byte integer field                         |
    | MYSQL_TYPE_INT24      | 3-byte integer field                         |
    | MYSQL_TYPE_LONGLONG   | 8-byte integer field                         |
    | MYSQL_TYPE_DECIMAL    | decimal field                                |
    | MYSQL_TYPE_NEWDECIMAL | precision math decimal field                 |
    | MYSQL_TYPE_FLOAT      | 4-byte single precision floating point field |
    | MYSQL_TYPE_DOUBLE     | 8-byte double precision floating point field |
    | MYSQL_TYPE_BIT        | 1-64 bits field                              |
    | MYSQL_TYPE_TIMESTAMP  | timestamp field                              |
    | MYSQL_TYPE_DATE       | date field                                   |
    | MYSQL_TYPE_TIME       | time field                                   |
    | MYSQL_TYPE_DATETIME   | datetime field                               |
    | MYSQL_TYPE_YEAR       | 1-byte year field (range = 1901 - 2155)      |
    | MYSQL_TYPE_STRING     | char or binary field                         |
    | MYSQL_TYPE_VAR_STRING | varchar or varbinary field                   |
    | MYSQL_TYPE_BLOB       | blob or text field                           |
    | MYSQL_TYPE_SET        | set field                                    |
    | MYSQL_TYPE_ENUM       | enum field                                   |
    | MYSQL_TYPE_GEOMETRY   | spatial field                                |
    | MYSQL_TYPE_NULL       | NULL-type field                              |

* `MYSQL_FIELD_OFFSET`

  This is a type-safe representation of an offset into a MySQL field list. Offsets are field numbers
  within a row, beginning at zero.

* `MYSQL_ROW_OFFSET`

  Represents an offset in a `MYSQL_RES`, pointing to an actual `MYSQL_ROW`.
