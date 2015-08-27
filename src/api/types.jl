typealias MYSQL Ptr{Void}
typealias MYSQL_RES Ptr{Void}
typealias MYSQL_ROW Vector{ByteString}
typealias MYSQL_FIELD_OFFSET UInt32

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

type MYSQL_FIELD
    c_mysql_field::_MYSQL_FIELD_
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

function MYSQL_FIELD(c_mysql_field::_MYSQL_FIELD_)
    MYSQL_FIELD(
        c_mysql_field,
        bytestring(c_mysql_field.name),
        bytestring(c_mysql_field.table),
        bytestring(c_mysql_field.db),
        bytestring(c_mysql_field.catalog),
        bytestring(c_mysql_field.def),
        c_mysql_field.length,
        c_mysql_field.max_length,
        c_mysql_field.flags,
        c_mysql_field.decimals,
        c_mysql_field.carsetnr,
        c_mysql_field.field_type
    )
end

type _MY_CHARSET_INFO_
    c_charset_info::_MY_CHARSET_INFO_
    number::Uint32
    state::Uint32
    csname::Ptr{Uint8}
    name::Ptr{Uint8}
    comment::Ptr{Uint8}
    dir::Ptr{Uint8}
    mbminlen::Ptr{Uint8}
    mbmaxlen::Ptr{Uint8}
end

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

function MY_CHARSET_INFO(c_charset_info::_MY_CHARSET_INFO_)
    MY_CHARSET_INFO(
        c_charset_info,
        c_charset_info.number
        c_charset_info.state
        bytestring(c_charset_info.csname)
        bytestring(c_charset_info.name)
        bytestring(c_charset_info.comment)
        bytestring(c_charset_info.dir)
        c_charset_info.mbminlen
        c_charset_info.mbmaxlen
    )
end
