# Link to MariaDB C Client (system-dependent)
let
    global mariadb_lib
    succeeded = false
    if !isdefined(:mariadb_lib)
        @linux_only   lib_choices = ["libmariadbclient", "libmariadbclient.so" ]
        @windows_only lib_choices = ["libmariadb", "libmariadb.lib"]
        @osx_only     lib_choices = ["libmysqlclient.dylib","libmysqlclient"]
        local lib
        for lib in lib_choices
            try
                Libdl.dlopen(lib)
                succeeded = true
                break
            end
        end
        succeeded || error("MariaDB client library library not found")
        @eval const mariadb_lib = $lib
    end
end
