module MariaDB
    include(joinpath("mariadb", "locatelib.jl"))
    include(joinpath("mariadb", "errors.jl"))
    include(joinpath("mariadb", "types.jl"))
    include(joinpath("mariadb", "funcs.jl"))
end
