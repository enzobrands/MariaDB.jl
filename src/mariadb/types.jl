export MYSQL, MYSQL_RES, MYSQL_ROW, MYSQL_FIELD_OFFSET

typealias MYSQL Ptr{Void}
typealias MYSQL_RES Ptr{Void}
typealias MYSQL_ROW Vector{ByteString}
typealias MYSQL_FIELD_OFFSET UInt32
typealias MYSQL_ROW_OFFSET Ptr{Void}

macro c_str_2_str(c_str)
    return :($c_str == C_NULL ? "" : bytestring($c_str))
end

macro str_2_c_str(str)
    return :($str == "" ? Base.convert(Ptr{UInt8}, C_NULL) : pointer($str))
end

type _MYSQL_FIELD_
    name::Ptr{Uint8}
    org_name::Ptr{Uint8}
    table::Ptr{Uint8}
    org_table::Ptr{Uint8}
    db::Ptr{Uint8}
    catalog::Ptr{Uint8}
    def::Ptr{Uint8}
    @windows_only length::Uint32
    @windows_only max_length::Uint32
    @unix_only length::Uint
    @unix_only max_length::Uint
    name_length::Uint32
    org_name_length::Uint32
    table_length::Uint32
    org_table_length::Uint32
    db_length::Uint32
    catalog_lenght::Uint32
    def_length::Uint32
    flags::Uint32
    decimals::Uint32
    charsetnr::Uint32
    field_type::Uint
    extension::Ptr{Void}
end
_MYSQL_FIELD_() = _MYSQL_FIELD_(C_NULL, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL,
                                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, C_NULL)

export MYSQL_FIELD

type MYSQL_FIELD
    name::String
    table::String
    db::String
    catalog::String
    def::String
    length::Uint
    max_length::Uint
    flags::Uint
    decimals::Uint
    charsetnr::Uint
    field_type::Uint
end
MYSQL_FIELD() = MYSQL_FIELD("", "", "", "", "", 0, 0, 0, 0, 0, 0)
function MYSQL_FIELD(c_mysql_field::_MYSQL_FIELD_)
    MYSQL_FIELD(
        @c_str_2_str(c_mysql_field.name),
        @c_str_2_str(c_mysql_field.table),
        @c_str_2_str(c_mysql_field.db),
        @c_str_2_str(c_mysql_field.catalog),
        @c_str_2_str(c_mysql_field.def),
        c_mysql_field.length,
        c_mysql_field.max_length,
        c_mysql_field.flags,
        c_mysql_field.decimals,
        c_mysql_field.charsetnr,
        c_mysql_field.field_type
    )
end

type _MY_CHARSET_INFO_
    number::Uint32
    state::Uint32
    csname::Ptr{Uint8}
    name::Ptr{Uint8}
    comment::Ptr{Uint8}
    dir::Ptr{Uint8}
    mbminlen::Uint32
    mbmaxlen::Uint32
end
_MY_CHARSET_INFO_() = _MY_CHARSET_INFO_(0, 0, C_NULL, C_NULL, C_NULL, C_NULL, 0, 0)

export MY_CHARSET_INFO

type MY_CHARSET_INFO
    number::Uint
    state::Uint
    csname::String
    name::String
    comment::String
    dir::String
    mbminlen::Uint
    mbmaxlen::Uint
end
MY_CHARSET_INFO() = MY_CHARSET_INFO(0, 0, "", "", "", "", 0, 0)
function MY_CHARSET_INFO(c_charset_info::_MY_CHARSET_INFO_)
    MY_CHARSET_INFO(
        c_charset_info.number,
        c_charset_info.state,
        @c_str_2_str(c_charset_info.csname),
        @c_str_2_str(c_charset_info.name),
        @c_str_2_str(c_charset_info.comment),
        @c_str_2_str(c_charset_info.dir),
        c_charset_info.mbminlen,
        c_charset_info.mbmaxlen
    )
end

export MYSQL_FIELD_TYPE

enum(MYSQL_FIELD_TYPE,
    MYSQL_TYPE_DECIMAL=0,
    MYSQL_TYPE_TINY=1,
    MYSQL_TYPE_SHORT=2,
    MYSQL_TYPE_LONG=3,
    MYSQL_TYPE_FLOAT=4,
    MYSQL_TYPE_DOUBLE=5,
    MYSQL_TYPE_NULL=6,
    MYSQL_TYPE_TIMESTAMP=7,
    MYSQL_TYPE_LONGLONG=8,
    MYSQL_TYPE_INT24=9,
    MYSQL_TYPE_DATE=10,
    MYSQL_TYPE_TIME=11,
    MYSQL_TYPE_DATETIME=12,
    MYSQL_TYPE_YEAR=13,
    MYSQL_TYPE_NOWDATE=14,
    MYSQL_TYPE_VARCHAR=15,
    MYSQL_TYPE_BIT=16,
    MYSQL_TYPE_TIMESTAMP2=17,
    MYSQL_TYPE_DATETIME2=18,
    MYSQL_TYPE_TIME2=19,
    MYSQL_TYPE_NEWDECIMAL=246,
    MYSQL_TYPE_ENUM=247,
    MYSQL_TYPE_SET=248,
    MYSQL_TYPE_TINY_BLOB=249,
    MYSQL_TYPE_MEDIUM_BLOB=250,
    MYSQL_TYPE_LONG_BLOB=251,
    MYSQL_TYPE_BLOB=252,
    MYSQL_TYPE_VAR_STRING=253,
    MYSQL_TYPE_STRING=254,
    MYSQL_TYPE_GEOMETRY=255
)

export MYSQL_TIMESTAMP_TYPE

@enum(MYSQL_TIMESTAMP_TYPE,
    MYSQL_TIMESTAMP_NONE=-2,
    MYSQL_TIMESTAMP_ERROR=-1,
    MYSQL_TIMESTAMP_DATE=0,
    MYSQL_TIMESTAMP_DATETIME=1,
    MYSQL_TIMESTAMP_TIME=2
)

export MYSQL_TIME

type MYSQL_TIME
    year::Uint
    month::Uint
    day::Uint
    hour::Uint
    minute::Uint
    second::Uint
    @windows_only second_part::Uint32
    @unix_only second_part::Uint
    neg::Int
    time_type::Int
end

export MYSQL_OPTION

@enum(MYSQL_OPTION,
    MYSQL_OPT_CONNECT_TIMEOUT=0,
    MYSQL_OPT_COMPRESS=1,
    MYSQL_OPT_NAMED_PIPE=2,
    MYSQL_INIT_COMMAND=3,
    MYSQL_READ_DEFAULT_FILE=4,
    MYSQL_READ_DEFAULT_GROUP=5,
    MYSQL_SET_CHARSET_DIR=6,
    MYSQL_SET_CHARSET_NAME=7,
    MYSQL_OPT_LOCAL_INFILE=8,
    MYSQL_OPT_PROTOCOL=9,
    MYSQL_SHARED_MEMORY_BASE_NAME=10,
    MYSQL_OPT_READ_TIMEOUT=11,
    MYSQL_OPT_WRITE_TIMEOUT=12,
    MYSQL_OPT_USE_RESULT=13,
    MYSQL_OPT_USE_REMOTE_CONNECTION=14,
    MYSQL_OPT_USE_EMBEDDED_CONNECTION=15,
    MYSQL_OPT_GUESS_CONNECTION=16,
    MYSQL_SET_CLIENT_IP=17,
    MYSQL_SECURE_AUTH=18,
    MYSQL_REPORT_DATA_TRUNCATION=19,
    MYSQL_OPT_RECONNECT=20,
    MYSQL_OPT_SSL_VERIFY_SERVER_CERT=21,
    MYSQL_PLUGIN_DIR=22,
    MYSQL_DEFAULT_AUTH=23,
    MYSQL_ENABLE_CLEARTEXT_PLUGIN=24,

    MYSQL_PROGRESS_CALLBACK=5999,
    MYSQL_OPT_NONBLOCK=6000
)

export MYSQL_PROTOCOL_TYPE

@enum(MYSQL_PROTOCOL_TYPE,
    MYSQL_PROTOCOL_DEFAULT=0,
    MYSQL_PROTOCOL_TCP=1,
    MYSQL_PROTOCOL_SOCKET=2,
    MYSQL_PROTOCOL_PIPE=3,
    MYSQL_PROTOCOL_MEMORY=4
)

export MYSQL_STATUS

@enum(MYSQL_STATUS,
    MYSQL_STATUS_READY=0,
    MYSQL_STATUS_GET_RESULT=1,
    MYSQL_STATUS_USE_RESULT=2,
    MYSQL_STATUS_STATEMENT_GET_RESULT=3
)

export MYSQL_SET_OPTION

@enum(MYSQL_SET_OPTION,
    MYSQL_OPTION_MULTI_STATEMENTS_ON=0,
    MYSQL_OPTION_MULTI_STATEMENTS_OFF=1
)

export MYSQL_NO_MORE_RESULTS,
       MYSQL_SHUTDOWN_KILLABLE_CONNECT,
       MYSQL_SHUTDOWN_KILLABLE_TRANS,
       MYSQL_SHUTDOWN_KILLABLE_LOCK_TABLE,
       MYSQL_SHUTDOWN_KILLABLE_UPDATE

const MYSQL_NO_MORE_RESULTS               = Int(-1)

const MYSQL_SHUTDOWN_KILLABLE_CONNECT     = UInt8(0x01)
const MYSQL_SHUTDOWN_KILLABLE_TRANS       = UInt8(0x02)
const MYSQL_SHUTDOWN_KILLABLE_LOCK_TABLE  = UInt8(0x04)
const MYSQL_SHUTDOWN_KILLABLE_UPDATE      = Uint8(0x08)

export MYSQL_SHUTDOWN_LEVEL

@enum(MYSQL_SHUTDOWN_LEVEL,
    SHUTDOWN_DEFAULT=0,
    SHUTDOWN_WAIT_CONNECTIONS=MYSQL_SHUTDOWN_KILLABLE_CONNECT,
    SHUTDOWN_WAIT_TRANSACTIONS=MYSQL_SHUTDOWN_KILLABLE_TRANS,
    SHUTDOWN_WAIT_UPDATES=MYSQL_SHUTDOWN_KILLABLE_UPDATE,
    SHUTDOWN_WAIT_ALL_BUFFERS=(MYSQL_SHUTDOWN_KILLABLE_UPDATE<<1),
    SHUTDOWN_WAIT_CRITICAL_BUFFERS=(MYSQL_SHUTDOWN_KILLABLE_UPDATE<<1)+1
)

const CLIENT_LONG_PASSWORD           = UInt32(0x00000001)
const CLIENT_FOUND_ROWS              = UInt32(0x00000002)
const CLIENT_LONG_FLAG               = UInt32(0x00000004)
const CLIENT_CONNECT_WITH_DB         = UInt32(0x00000008)
const CLIENT_NO_SCHEMA               = UInt32(0x00000010)
const CLIENT_COMPRESS                = UInt32(0x00000020)
const CLIENT_ODBC                    = UInt32(0x00000040)
const CLIENT_LOCAL_FILES             = UInt32(0x00000080)
const CLIENT_IGNORE_SPACE            = UInt32(0x00000100)
const CLIENT_PROTOCOL_41             = UInt32(0x00000200)
const CLIENT_INTERACTIVE             = UInt32(0x00000400)
const CLIENT_SSL                     = UInt32(0x00000800)
const CLIENT_IGNORE_SIGPIPI          = UInt32(0x00001000)
const CLIENT_TRANSACTIONS            = UInt32(0x00002000)
const CLIENT_RESERVED                = UInt32(0x00004000)
const CLIENT_SECURE_CONNECTION       = UInt32(0x00008000)
const CLIENT_MULTI_STATEMENTS        = UInt32(0x00010000)
const CLIENT_MULTI_RESULTS           = UInt32(0x00020000)
const CLIENT_PS_MULTI_RESULTS        = UInt32(0x00040000)
const CLIENT_PLUGIN_AUTH             = UInt32(0x00080000)
const CLIENT_PROGRESS                = UInt32(0x20000000)
const CLIENT_SSL_VERIFY_SERVER_CERT  = UInt32(0x40000000)

const REFRESH_GRANT                  = UInt32(0x00000001)
const REFRESH_LOG                    = UInt32(0x00000002)
const REFRESH_TABLES                 = UInt32(0x00000004)
const REFRESH_HOSTS                  = UInt32(0x00000008)
const REFRESH_STATUS                 = UInt32(0x00000010)
const REFRESH_THREADS                = UInt32(0x00000020)
const REFRESH_SLAVE                  = UInt32(0x00000040)
const REFRESH_MASTER                 = UInt32(0x00000080)
const REFRESH_ERROR_LOG              = UInt32(0x00000100)
const REFRESH_ENGINE_LOG             = UInt32(0x00000200)
const REFRESH_BINARY_LOG             = UInt32(0x00000400)
const REFRESH_RELAY_LOG              = UInt32(0x00000800)
const REFRESH_GENERAL_LOG            = UInt32(0x00001000)
const REFRESH_SLOW_LOG               = UInt32(0x00002000)
const REFRESH_READ_LOCK              = UInt32(0x00004000)
const REFRESH_CHECKPOINT             = UInt32(0x00008000)
const REFRESH_QUERY_CACHE            = UInt32(0x00010000)
const REFRESH_QUERY_CACHE_FREE       = UInt32(0x00020000)
const REFRESH_DES_KEY_FILE           = UInt32(0x00040000)
const REFRESH_USER_RESOURCES         = UInt32(0x00080000)
const REFRESH_TABLE_STATS            = UInt32(0x00100000)
const REFRESH_INDEX_STATS            = UInt32(0x00200000)
const REFRESH_USER_STATS             = UInt32(0x00400000)
const REFRESH_FAST                   = UInt32(0x80000000)
